// To parse this JSON data, do
//
//     final editProfile = editProfileFromJson(jsonString);

import 'dart:convert';

EditProfile editProfileFromJson(String str) => EditProfile.fromJson(json.decode(str));

String editProfileToJson(EditProfile data) => json.encode(data.toJson());

class EditProfile {
    EditProfile({
        this.success,
        this.profileImage,
    });

    int success;
    ProfileImage profileImage;

    factory EditProfile.fromJson(Map<String, dynamic> json) => EditProfile(
        success: json["success"],
        profileImage: ProfileImage.fromJson(json["profile_image"]),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "profile_image": profileImage.toJson(),
    };
}

class ProfileImage {
    ProfileImage({
        this.profileImage,
    });

    String profileImage;

    factory ProfileImage.fromJson(Map<String, dynamic> json) => ProfileImage(
        profileImage: json["profile_image"],
    );

    Map<String, dynamic> toJson() => {
        "profile_image": profileImage,
    };
}
