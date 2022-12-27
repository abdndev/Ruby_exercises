export const pi = 3.14;
export const e = 2.718;

export const square = (x) => {
  return x * x;
};

export const surfaceArea = (r) => {
  return 4 * pi * square(r);
};


//Another way to export several values
//export { pi, e, square, surfaceArea };
