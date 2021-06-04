import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:after_init/after_init.dart';

void main() {
  testWidgets('initState() is called exactly once',
      (WidgetTester tester) async {
    //Arrange
    final mock = MockObject();
    final widget = TestWidget(
      onInitState: () => mock.bar(),
      onDidInitState: () {},
      onDidChangeDependencies: () {},
      onBuild: () {},
    );

    //Act
    await tester.pumpWidget(widget);

    //Assert
    verify(mock.bar()).called(1);
  });

  testWidgets('didInitState() is called exactly once',
      (WidgetTester tester) async {
    //Arrange
    final mock = MockObject();
    final widget = TestWidget(
      onInitState: () {},
      onDidInitState: () => mock.bar(),
      onDidChangeDependencies: () {},
      onBuild: () {},
    );

    //Act
    await tester.pumpWidget(widget);

    //Assert
    verify(mock.bar()).called(1);
  });

  testWidgets('didChangeDependencies() is called exactly once',
      (WidgetTester tester) async {
    //Arrange
    final mock = MockObject();
    final widget = TestWidget(
      onInitState: () {},
      onDidInitState: () {},
      onDidChangeDependencies: () => mock.bar(),
      onBuild: () {},
    );

    //Act
    await tester.pumpWidget(widget);

    //Assert
    verify(mock.bar()).called(1);
  });

  testWidgets(
      'didInitState() is called exactly once even if didChangeDependencies() is called multiple times',
      (WidgetTester tester) async {
    //Arrange
    final key = GlobalKey<_TestWidgetState>();
    final mock = MockObject();
    final widget = TestWidget(
      key: key,
      onInitState: () {},
      onDidInitState: () => mock.bar(),
      onDidChangeDependencies: () {},
      onBuild: () {},
    );

    //Act
    await tester.pumpWidget(widget);
    key.currentState!.didChangeDependencies();
    key.currentState!.didChangeDependencies();

    //Assert
    verify(mock.bar()).called(1);
  });

  testWidgets(
      'lifecycle method order is: initState(), didInitState(), didChangeDependencies(), build()',
      (WidgetTester tester) async {
    //Arrange
    final mock1 = MockObject();
    final mock2 = MockObject();
    final mock3 = MockObject();
    final mock4 = MockObject();
    final widget = TestWidget(
      onInitState: () => mock1.bar(),
      onDidInitState: () => mock2.bar(),
      onDidChangeDependencies: () => mock3.bar(),
      onBuild: () => mock4.bar(),
    );

    //Act
    await tester.pumpWidget(widget);

    //Assert
    verifyInOrder([
      mock1.bar(),
      mock2.bar(),
      mock3.bar(),
      mock4.bar(),
    ]);
  });
}

/// Fake class to mock.
class Foo {
  void bar() {}
}

/// Mock for verifying callback invocations.
class MockObject extends Mock implements Foo {}

/// Test widget which provides callbacks for [State] lifecycle events.
class TestWidget extends StatefulWidget {
  final Function() onInitState;
  final Function() onDidInitState;
  final Function() onDidChangeDependencies;
  final Function() onBuild;

  const TestWidget({
    Key? key,
    required this.onInitState,
    required this.onDidInitState,
    required this.onDidChangeDependencies,
    required this.onBuild,
  }) : super(key: key);

  @override
  _TestWidgetState createState() => _TestWidgetState();
}

class _TestWidgetState extends State<TestWidget>
    with AfterInitMixin<TestWidget> {
  @override
  void initState() {
    super.initState();
    widget.onInitState.call();
  }

  @override
  void didInitState() {
    widget.onDidInitState.call();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.onDidChangeDependencies.call();
  }

  @override
  Widget build(BuildContext context) {
    widget.onBuild.call();
    return Container();
  }
}
