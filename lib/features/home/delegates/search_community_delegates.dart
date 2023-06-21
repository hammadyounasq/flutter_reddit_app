import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/features/community/controller/community_controller.dart';
import 'package:reddit/models/community_model.dart';
import 'package:routemaster/routemaster.dart';

import '../../../core/commen/error_text.dart';
import '../../../core/commen/loader.dart';

class SearchCommunityDelegates extends SearchDelegate {
  final WidgetRef ref;
  SearchCommunityDelegates(this.ref);
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: Icon(Icons.close),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return null;
  }

  @override
  Widget buildResults(BuildContext context) {
    return SizedBox();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return ref.watch(searchCommunitydelegates(query)).when(
        data: (communities) => ListView.builder(
            itemCount: communities.length,
            itemBuilder: (context, index) {
              final community = communities[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(community.banner),
                ),
                title: Text('${community.name}'),
                onTap: () => navigater(context, community.name),
              );
            }),
        error: (error, staskTrace) => ErrorText(error: error.toString()),
        loading: () => Loader());
  }

  void navigater(BuildContext context, String communityName) {
    Routemaster.of(context).push('/r/${communityName}');
  }
}
