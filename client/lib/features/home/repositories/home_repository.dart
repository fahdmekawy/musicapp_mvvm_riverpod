import 'dart:io';

import 'package:client/core/failure/failure.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/constants/server_constants.dart';

part 'home_repository.g.dart';

@riverpod
HomeRepository homeRepository(HomeRepositoryRef ref) => HomeRepository();

class HomeRepository {
  Future<Either<Failure, String>> uploadSong({
    required File selectedAudio,
    required File selectedThumbnail,
    required String songName,
    required String artist,
    required String hexCode,
    required String token,
  }) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('${ServerConstants.baseUrl}song/upload'),
      );

      request
        ..files.addAll(
          [
            await http.MultipartFile.fromPath('song', selectedAudio.path),
            await http.MultipartFile.fromPath(
                'thumbnail', selectedThumbnail.path),
          ],
        )
        ..fields.addAll(
          {
            'artist': artist,
            'song_name': songName,
            'hex_code': hexCode,
          },
        )
        ..headers.addAll(
          {
            'x-auth-token': token,
          },
        );

      final res = await request.send();

      if (res.statusCode != 201) {
        return Left(Failure(await res.stream.bytesToString()));
      }

      return Right(await res.stream.bytesToString());
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
