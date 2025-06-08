import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ottstudy/blocs/rank/my_rank_cubit.dart';
import 'package:ottstudy/blocs/rank/rank_cubit.dart';
import 'package:ottstudy/ui/widget/base_screen.dart';
import 'package:ottstudy/ui/widget/custom_snack_bar.dart';
import '../../../blocs/base_bloc/base_state.dart';
import '../../../data/models/rank_model.dart';
import '../../../gen/assets.gen.dart';

import '../../../res/colors.dart';
import '../../../util/constants.dart';
import '../../widget/base_progress_indicator.dart';
import '../../widget/common_widget.dart';
import '../../widget/custom_selector.dart';
import '../../widget/custom_text_label.dart';

class RankScreen extends StatelessWidget {
  const RankScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => RankCubit(),
        ),
        BlocProvider(
          create: (_) => MyRankCubit(),
        )
      ],
      child: RankBody(),
    );
  }
}

class RankBody extends StatefulWidget {
  const RankBody({super.key});

  @override
  State<RankBody> createState() => _RankBodyState();
}

class _RankBodyState extends State<RankBody> {
  @override
  void initState() {
    super.initState();
    final defaultCategory = Constants.rankSelector.first.id;
    getData(defaultCategory);
  }


  Future<void> getData(String category) async {
    Map<String, dynamic> param = {
      "category": category
    };
    await Future.wait([
      context.read<RankCubit>().getRank(param),
      context.read<MyRankCubit>().getMyRank(param)
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      hiddenIconBack: true,
      colorBackground: AppColors.background_white,
      colorAppBar: AppColors.background_white,
      messageNotify: Stack(
        children: [
          CustomSnackBar<RankCubit>(),
          CustomSnackBar<MyRankCubit>()
        ],
      ),
      title: const Align(
        alignment: Alignment.centerLeft,
        child: CustomTextLabel(
          'Bảng xếp hạng',
          gradient: AppColors.base_gradient_3,
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
      ),
      rightWidgets: [Assets.images.icChart.image(), SizedBox(width: 20,)],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          CustomSelector(
            selectedColor: AppColors.base_gradient_2,
            items: Constants.rankSelector,
            onTap: (id, index) {
              getData(id);
            },
          ),
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: CustomTextLabel('Vị trí của tôi', fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          BlocBuilder<MyRankCubit, BaseState>(
            builder: (context, state) {
              if (state is LoadingState) {
                return const Center(child: BaseProgressIndicator(color: AppColors.black,));
              }
              if (state is LoadedState<RankModel>) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: CommonWidget.rankStudentCard(state.data),
                );
              }
              return const SizedBox.shrink();
            },
          ),
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: CustomTextLabel('Top 10 học sinh', fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: BlocBuilder<RankCubit, BaseState>(
              builder: (context, state) {
                if (state is LoadingState) {
                  return const Center(child: BaseProgressIndicator(color: AppColors.black,));
                }
                if (state is LoadedState<List<RankModel>>) {
                  return ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: state.data.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (_, index) {
                      return CommonWidget.rankStudentCard(state.data[index]);
                    },
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),

    );
  }
}

