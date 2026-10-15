// import 'package:flutter/material.dart';

// import '../../../auth/data/models/user_model.dart';

// class UserProfilePage extends StatelessWidget {
//   final String token;
//   final UserModel user;

//   const UserProfilePage({super.key, required this.token, required this.user});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('User Profile'),
//         backgroundColor: Colors.blue.shade600,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             // Profile Avatar
//             CircleAvatar(
//               radius: 50,
//               backgroundColor: Colors.blue.shade200,
//               child: Text(
//                 user.systemUser.fname[0] + user.systemUser.lname[0], // initials
//                 style: const TextStyle(
//                   fontSize: 32,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 16),

//             // Name Card
//             Card(
//               elevation: 3,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: ListTile(
//                 leading: const Icon(Icons.person, color: Colors.blue),
//                 title: Text(
//                   '${user.systemUser.fname} ${user.systemUser.lname}',
//                   style: const TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 subtitle: const Text('Full Name'),
//               ),
//             ),
//             const SizedBox(height: 12),

//             // Email Card
//             Card(
//               elevation: 3,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: ListTile(
//                 leading: const Icon(Icons.email, color: Colors.blue),
//                 title: Text(user.systemUser.email),
//                 subtitle: const Text('Email'),
//               ),
//             ),
//             const SizedBox(height: 12),

//             // Mobile Card
//             Card(
//               elevation: 3,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: ListTile(
//                 leading: const Icon(Icons.phone, color: Colors.blue),
//                 title: Text(user.systemUser.mobile),
//                 subtitle: const Text('Mobile'),
//               ),
//             ),
//             const SizedBox(height: 12),

//             // User Type Card
//             Card(
//               elevation: 3,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: ListTile(
//                 leading: const Icon(Icons.account_box, color: Colors.blue),
//                 title: Text(user.userType.type),
//                 subtitle: const Text('User Type'),
//               ),
//             ),
//             const SizedBox(height: 12),

//             // Custom ID Card
//             Card(
//               elevation: 3,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: ListTile(
//                 leading: const Icon(Icons.badge, color: Colors.blue),
//                 title: Text(user.systemUser.customId),
//                 subtitle: const Text('Custom ID'),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
