import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:golf_live_scoring/ui/common/data/progress_state.dart';

class CommonScreenWrapper<C extends Cubit<S>, S extends ProgressState> extends StatelessWidget {
  const CommonScreenWrapper({
    super.key,
    required this.cubit,
    required this.contentBuilder,
  });

  final C cubit;
  final WidgetBuilder contentBuilder;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<C, S>(
        bloc: cubit,
        buildWhen: (prev, curr) => prev.inProgress != curr.inProgress,
        builder: (context, state) {
          return PopScope(
            canPop: !state.inProgress,
            child: Scaffold(
              backgroundColor: Colors.green,
              body: Stack(
                children: [
                  Visibility(
                    visible: !state.inProgress,
                    child: contentBuilder.call(context),
                  ),
                  if (state.inProgress) Center(child: CircularProgressIndicator()),
                ],
              ),
            ),
          );
        });
  }
}
