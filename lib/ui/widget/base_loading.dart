import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/base_bloc/base.dart';
import 'widget.dart';

class CustomLoading<T extends Cubit<BaseState>> extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<T, BaseState>(
      builder: (_, state) {
        if (state is LoadingState) {
          return GestureDetector(
            onTap: () {},
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black12,
              ),
              child: Center(
                child: BaseProgressIndicator(),
              ),
            ),
          );
        }
        return Wrap();
      },
    );
  }
}
