// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'welcome_view_model.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$WelcomeViewModel on _WelcomeViewModelBase, Store {
  final _$currentPageIndexAtom =
      Atom(name: '_WelcomeViewModelBase.currentPageIndex');

  @override
  int get currentPageIndex {
    _$currentPageIndexAtom.reportRead();
    return super.currentPageIndex;
  }

  @override
  set currentPageIndex(int value) {
    _$currentPageIndexAtom.reportWrite(value, super.currentPageIndex, () {
      super.currentPageIndex = value;
    });
  }

  final _$pageControllerAtom =
      Atom(name: '_WelcomeViewModelBase.pageController');

  @override
  PageController? get pageController {
    _$pageControllerAtom.reportRead();
    return super.pageController;
  }

  @override
  set pageController(PageController? value) {
    _$pageControllerAtom.reportWrite(value, super.pageController, () {
      super.pageController = value;
    });
  }

  final _$_WelcomeViewModelBaseActionController =
      ActionController(name: '_WelcomeViewModelBase');

  @override
  void changePage(int index) {
    final _$actionInfo = _$_WelcomeViewModelBaseActionController.startAction(
        name: '_WelcomeViewModelBase.changePage');
    try {
      return super.changePage(index);
    } finally {
      _$_WelcomeViewModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
currentPageIndex: ${currentPageIndex},
pageController: ${pageController}
    ''';
  }
}
