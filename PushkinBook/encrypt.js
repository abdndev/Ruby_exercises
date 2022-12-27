const encrypt = (text) => {
    //let i = 0;
    //let result = '';
    //while (i < text.length) {
      //if ((i + 1) % 2 === 0) {
        //return (`$text[i]$text[i + 1]`).reverse;
    let i = 0;
    let result = '';
    let sym;
    for (i < text.length; i += 1;) {
      sym = text[i - 1]+ text[i];
      //i % 2 === 0;
        result = (`${sym}${result}`);
        result ++;
    }
      //sym += sym;
      return result;
      //i++;
    };
    