import 'dart:async';

import 'package:flutter/material.dart';
import 'package:new_begining/utilities/cotrollers/loading_screen_container.dart';

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
    final _text = StreamController<String>();
    _text.add(text);

    final state = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    final overlay = OverlayEntry(
      opaque: true,
      builder: (context) {
        return Material(
          color: Colors.black.withAlpha(150),
          child: Center(
            child: Container(
              constraints: BoxConstraints(
                maxHeight: size.height * 0.80,
                maxWidth: size.width * 0.80,
                minHeight: size.height * 0.40,
                minWidth: size.width * 0.40,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 10),
                      const CircularProgressIndicator(),
                      const SizedBox(height: 20),
                      StreamBuilder(
                        stream: _text.stream,
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
        _text.close();
        overlay.remove();
        return true;
      },
      updateLoadingScreen: (text) {
        _text.add(text);
        return true;
      },
    );
  }
}
