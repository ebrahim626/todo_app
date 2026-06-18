import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/src/features/menu_drawer/menu_items/profile/model/response/profile_model.dart';
import 'package:todo_app/src/features/menu_drawer/menu_items/profile/repository/profile_repository.dart';
import 'package:todo_app/src/shared/toast/toast.dart';
import 'dart:developer';

typedef ProfileNotifier =
    AutoDisposeAsyncNotifierProvider<ProfileProvider, void>;

final profileProvider = ProfileNotifier(ProfileProvider.new);

class ProfileProvider extends AutoDisposeAsyncNotifier {
  UserProfileModel? userProfileData;
  TextEditingController? emailController;
  TextEditingController? nameController;

  @override
  FutureOr<dynamic> build() {
    getProfile();
  }

  Future<void> getProfile() async {
    try {
      EasyLoading.show();
      final repo = ref.read(profileRepository);
      final response = await repo.getProfile();

      if (response.statusCode == 200 || response.statusCode == 201) {
        userProfileData = UserProfileResponseModel.fromJson(response.data).data;
        log("data = ${userProfileData?.firstName}");

        emailController?.text = userProfileData?.email ?? "";
        nameController?.text = userProfileData?.firstName ?? "";
      } else {
        FlashCard.showError(errorMessage: "Failed to fetch user data");
      }
    } catch (e) {
      FlashCard.showError(
        errorMessage: "An error occurred while fetching user data : $e",
      );
    } finally {
      EasyLoading.dismiss();
    }
  }
}
