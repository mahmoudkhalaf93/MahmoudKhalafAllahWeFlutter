import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/item_model.dart';
import 'favorites_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  FavoritesCubit() : super(FavoritesInitial());

  String? get _uid => _auth.currentUser?.uid;

  Future<void> loadFavorites() async {
    if (_uid == null) return;
    emit(FavoritesLoading());
    try {
      final snapshot = await _firestore.collection('users').doc(_uid).collection('favorites').get();
      final favorites = snapshot.docs.map((doc) => ItemModel.fromJson(doc.data(), doc.id)).toList();
      emit(FavoritesLoaded(favorites));
    } catch (e) {
      emit(FavoritesError(e.toString()));
    }
  }

  Future<void> toggleFavorite(ItemModel item) async {
    if (_uid == null) return;
    
    final currentFavorites = state is FavoritesLoaded ? (state as FavoritesLoaded).favorites : <ItemModel>[];
    final isFavorite = currentFavorites.any((element) => element.firebaseId == item.firebaseId);

    try {
      final docRef = _firestore.collection('users').doc(_uid).collection('favorites').doc(item.firebaseId);
      
      if (isFavorite) {
        await docRef.delete();
        final updatedList = currentFavorites.where((element) => element.firebaseId != item.firebaseId).toList();
        emit(FavoritesLoaded(updatedList));
      } else {
        await docRef.set(item.toJson());
        final updatedList = List<ItemModel>.from(currentFavorites)..add(item);
        emit(FavoritesLoaded(updatedList));
      }
    } catch (e) {
      emit(FavoritesError(e.toString()));
    }
  }

  bool isFavorite(String id) {
    if (state is FavoritesLoaded) {
      return (state as FavoritesLoaded).favorites.any((element) => element.firebaseId == id);
    }
    return false;
  }
}
