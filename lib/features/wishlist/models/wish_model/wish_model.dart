import 'acceptor.dart';
import 'category.dart';
import 'subcategory.dart';
import 'user.dart';

class WishModel {
	int? id;
	String? description;
	int? status;
	int? acceptorsCount;
	User? user;
	Category? category;
	Subcategory? subcategory;
	List<Acceptor>? acceptors;

	WishModel({
		this.id, 
		this.description, 
		this.status, 
		this.acceptorsCount, 
		this.user, 
		this.category, 
		this.subcategory, 
		this.acceptors, 
	});

	@override
	String toString() {
		return 'WishModel(id: $id, description: $description, status: $status, acceptorsCount: $acceptorsCount, user: $user, category: $category, subcategory: $subcategory, acceptors: $acceptors)';
	}

	factory WishModel.fromJson(Map<String, dynamic> json) => WishModel(
				id: json['id'] as int?,
				description: json['description'] as String?,
				status: json['status'] as int?,
				acceptorsCount: json['acceptors_count'] as int?,
				user: json['user'] == null
						? null
						: User.fromJson(json['user'] as Map<String, dynamic>),
				category: json['category'] == null
						? null
						: Category.fromJson(json['category'] as Map<String, dynamic>),
				subcategory: json['subcategory'] == null
						? null
						: Subcategory.fromJson(json['subcategory'] as Map<String, dynamic>),
				acceptors: (json['acceptors'] as List<dynamic>?)
						?.map((e) => Acceptor.fromJson(e as Map<String, dynamic>))
						.toList(),
			);

	Map<String, dynamic> toJson() => {
				'id': id,
				'description': description,
				'status': status,
				'acceptors_count': acceptorsCount,
				'user': user?.toJson(),
				'category': category?.toJson(),
				'subcategory': subcategory?.toJson(),
				'acceptors': acceptors?.map((e) => e.toJson()).toList(),
			};
}
