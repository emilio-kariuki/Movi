import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import '../../../ui/widgets/auth_button.dart';
import 'profile_viewmodel.dart';

class ProfileView extends StackedView<ProfileViewModel> {
  const ProfileView({super.key});

  @override
  Widget builder(
      BuildContext context, ProfileViewModel viewModel, Widget? child) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.black54,
        title: const Text(
          'Profile',
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onSelected: (value) {
              if (value == 'logout') {
                viewModel.logout();
              } else if (value == 'delete') {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    backgroundColor: const Color(0xFF292929),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    title: const Text(
                      'Are you sure you want to delete your account?',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    content: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          AuthButton(
                            width: 110,
                            height: 40,
                            borderRadius: 15,
                            color: Colors.blue,
                            text: 'Yes',
                            onPressed: () {
                              Navigator.of(context).pop();
                              viewModel.deleteAccount();
                            },
                          ),
                          const Spacer(),
                          AuthButton(
                            width: 110,
                            height: 40,
                            borderRadius: 15,
                            color: Colors.blue,
                            text: 'No',
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }
            },
            itemBuilder: (_) => [
              const PopupMenuItem<String>(
                  value: 'logout', child: Text('Logout')),
              const PopupMenuItem<String>(
                  value: 'delete', child: Text('Delete Account')),
            ],
          ),
        ],
      ),
      backgroundColor: Colors.black,
      body: viewModel.isBusy
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CircleAvatar(
                        radius: 45,
                        backgroundColor: Colors.blue,
                        child:
                            Icon(Icons.person, size: 50, color: Colors.white),
                      ),
                      const SizedBox(height: 16),
                      if (viewModel.user != null) ...[
                        Text(
                          viewModel.user!.name,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          viewModel.user!.email,
                          style:
                              const TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                      ],
                      const SizedBox(height: 24),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.favorite, color: Colors.blue),
                        title: const Text('My Favourites',
                            style: TextStyle(color: Colors.white)),
                        trailing: const Icon(Icons.chevron_right,
                            color: Colors.white),
                        onTap: viewModel.navigateToFavourites,
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  @override
  ProfileViewModel viewModelBuilder(BuildContext context) => ProfileViewModel();

  @override
  void onViewModelReady(ProfileViewModel viewModel) => viewModel.loadUser();
}
