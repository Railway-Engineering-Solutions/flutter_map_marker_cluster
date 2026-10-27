can_publish:
	dart format ./ && flutter analyze ./ && flutter test

publish:
	dart format ./ && flutter analyze ./ && flutter test && flutter pub pub publish