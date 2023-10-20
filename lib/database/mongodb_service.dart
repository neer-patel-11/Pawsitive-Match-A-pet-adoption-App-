

import 'package:mongo_dart/mongo_dart.dart';

class MongoDBService {
  late var _db;

  Future<void> connect() async {
    // final String dbUrl = 'mongodb://10.0.2.2:27017/sdp_project';
    final String dbUrl = 'mongodb+srv://businerashop:stalkyourstock@cluster0.logjhxd.mongodb.net/sdp_project?retryWrites=true&w=majority';

    _db = await Db.create(dbUrl);

    await _db.open();
    print('Connected to MongoDB');
  }

  Future<void> close() async {
    await _db.close();
    print('Connection to MongoDB closed');
  }


  Future<void> registerPet(Map<String, dynamic> pet) async {
    await connect();
    final petCollection = _db.collection('pets');
    await petCollection.insert(pet);
  }

  Future<Map<String, dynamic>?> findUserByEmail(String email) async {
    await connect();
    final usersCollection = _db.collection('users');
    final user = await usersCollection.findOne(where.eq('email', email));
    return user;
  }


  Future<Map<String, dynamic>?> findUserById(String id) async {
    await connect();
    print(id.toString());
    String userId = id.substring(10,34);
    print(userId);
    final usersCollection = _db.collection('users');
    final user;
    user = await usersCollection.findOne(where.id(ObjectId.parse(userId)));
    print(user);
    return user;
  }



  Future<void> registerUser(Map<String, dynamic> user) async {
    await connect();
    final usersCollection = _db.collection('users');
    await usersCollection.insert(user);
  }

  Future<List<Map<String, dynamic>>>  findPets() async {
      await connect();
      var pets;
      print("we are here bro");
      final petsCollection = _db.collection('pets');
      pets = await petsCollection.find().toList();
      // print(pets[1]);
      pets = pets.reversed.toList();
      return pets;


    return pets;
  }

  Future<Map<String, Object?>> getPet(dynamic id) async {
    await connect();
    final pet;
    print("Get Pet");
    // print(id);
    final petsCollection = _db.collection('pets');
    pet = await petsCollection.findOne(where.id(id));
    // print(pet);
    close();
    return pet;
  }

}