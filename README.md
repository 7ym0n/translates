translates
==========

translates is simple language translate adapter
it's can help me translate local language.

## USAGE

### How using translate?
	
#### CSV 
	create csv file, add to ./examples/locale
	create base.csv file respectively add in to ./examples/locale/zh and  ./examples/locale/en PATH
	./examples/locale/zh/base.csv file for example:
```csv
	"hello";"你好"
	"world";"世界"
	"local";"本地化"
	"game-start";"开始游戏"
```    
./examples/locale/en/base.csv file for example:
```csv
	"hello";"hello"
	"world";"world"
	"local";"localization"
	"game-start";"game start"
```    

In your program write:	
```scheme
	(use-modules (translates translate))
	(set-translate "csv" "./examples/locale" "zh" '(delimiter . #\;))
```

TODO translate:
```scheme
	(translate 'hello) => "你好"
	(translate 'world) => "世界"
	;;; designated use language environment
	(translate 'hello "en") => "hello"
	(translate 'local "en") => "localization"
```

### How to customize translate adapter?

you need new create a scheme file.this file must be include a <procedure get-translate-data>,
<procedure get-translate-data> must be Accept four parameters(keyword content local option),
keyword is (translate key), 
content is language file PATH, 
local is locale,
option is other option,

<procedure get-translate-data> return (translate 'key) of result  => value
will this file move to ../translates/adapter PATH 

This file looks like:
```scheme
	(define-module (translates adapter gettext)
	   #:use-module (translates utils)
	   #:export (get-translate-data))
	   
	(define (get-translate-data keyword content local option)
	   ;;; TODO
	   )
```

## EXAMPLE
Please reader test.scm