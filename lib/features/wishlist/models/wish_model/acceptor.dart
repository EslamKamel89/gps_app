import 'item.dart';
import 'user.dart';

class Acceptor {
	int? id;
	int? wishlistId;
	int? userId;
	String? itemType;
	int? itemId;
	Item? item;
	User? user;

	Acceptor({
		this.id, 
		this.wishlistId, 
		this.userId, 
		this.itemType, 
		this.itemId, 
		this.item, 
		this.user, 
	});

	@override
	String toString() {
		return 'Acceptor(id: $id, wishlistId: $wishlistId, userId: $userId, itemType: $itemType, itemId: $itemId, item: $item, user: $user)';
	}

	factory Acceptor.fromJson(Map<String, dynamic> json) => Acceptor(
				id: json['id'] as int?,
				wishlistId: json['wishlist_id'] as int?,
				userId: json['user_id'] as int?,
				itemType: json['item_type'] as String?,
				itemId: json['item_id'] as int?,
				item: json['item'] == null
						? null
						: Item.fromJson(json['item'] as Map<String, dynamic>),
				user: json['user'] == null
						? null
						: User.fromJson(json['user'] as Map<String, dynamic>),
			);

	Map<String, dynamic> toJson() => {
				'id': id,
				'wishlist_id': wishlistId,
				'user_id': userId,
				'item_type': itemType,
				'item_id': itemId,
				'item': item?.toJson(),
				'user': user?.toJson(),
			};
}
