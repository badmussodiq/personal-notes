import 'dart:async';

import 'package:flutter/material.dart';
import 'package:new_begining/utilities/controllers/loading_screen_container.dart';

class LoadingScreen {
  factory LoadingScreen() => _shared;

  static final LoadingScreen _shared = LoadingScreen._sharedInstance();

  LoadingScreen._sharedInstance();

  LoadingScreenController? loadingScreenController;

  void show({required BuildContext context, required String text}) {
    if (loadingScreenController?.updateLoadingScreen(text) ?? false) {
      return;
    } else {
      loadingScreenController = showOverLay(context: context, text: text);
    }
  }

  void hide() {
    loadingScreenController?.closeLoadingScreen();
    loadingScreenController = null;
  }

  LoadingScreenController showOverLay({
    required BuildContext context,
    required String text,
  }) {
    final text0 = StreamController<String>();
    text0.add(text);

    final state = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    final overlay = OverlayEntry(
      // opaque: true,
      builder: (context) {
        return Material(
          color: Colors.black.withAlpha(150),
          // color: Colors.black.withValues(alpha: 0.3),
          child: Center(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: size.width * 0.8,
                maxHeight: size.height * 0.8,
                minWidth: size.width * 0.5,
                minHeight: size.height * 0.2,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // const SizedBox(height: 20,),
                      const CircularProgressIndicator(),
                      // const SizedBox(height: 20),
                      StreamBuilder(
                        stream: text0.stream,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Text(
                              snapshot.data as String,
                              textAlign: TextAlign.center,
                            );
                          } else {
                            return Container();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );

    state.insert(overlay);

    return LoadingScreenController(
      closeLoadingScreen: () {
        text0.close();
        overlay.remove();
        return true;
      },
      updateLoadingScreen: (String text) {
        text0.add(text);
        return true;
      },
    );
  }
}
