#ifdef GL_ES
precision mediump float;
#endif

//  Function from Iñigo Quiles
//  https://www.shadertoy.com/view/MsS3Wc
vec3 hsb2rgb(in vec3 c) {
  vec3 rgb = clamp(abs(mod(c.x * 6.0 + vec3(0.0, 4.0, 2.0), 6.0) - 3.0) - 1.0, 0.0, 1.0);
  rgb = rgb * rgb * (3.0 - 2.0 * rgb);
  return c.z * mix(vec3(1.0), rgb, c.y);
}

void plus(inout vec3 col) {
  // 얕은 복사(레퍼런스 복사)가 이뤄지므로 실제로 vec3 col 값에 변화를 줄 수 있음.
  col = col + .5;
}

/*
void plus(out vec3 col) {
  // 인자의 레퍼런스값이 넘어오므로, col에 계산읗 해주면 실제 vec3 col값이 변경됨.
  col = col + .5;
}
*/

/*
void plus(in vec3 col) {
  // 인자로 전달받은 vec3 데이터에 0.5를 더해서 '리턴하지는 않음'
  // 그냥 더해주기만 함. 리턴값 타입이 'void'니까!
  // 복사된 데이터값만 넘어오기 때문에 어떤 계산을 해줘도 실제 vec3 col에는 아무런 변화가 없음.
  col = col + .5;
}
*/

void main() {
  // vec3 col = vec3(.0); // 기본값이 black(.0, .0, .0) 인 vec 데이터 생성
  vec3 col = vec3(.5); // inout과 out의 차이를 살펴보기 위해 초기값을 회색으로 지정
  plus(col); // plus() 라는 사용자 정의 함수에 vec3 col 값을 인자로 전달하면서 호출함.
  gl_FragColor = vec4(col, 1.);
}

/*
  참고로, plus() 함수에서 보듯이,
  앞에 리턴값 타입이 void가 붙으면
  해당 함수는 계산 결과로 별도의 리턴값이 없다는 의미임.

  void 자체가 '텅빈, 없는'이라는 뜻이라서
  C, C++, C# 같은 언어에서도 동일한 문법으로 사용됨.
*/

/*
  qualifier


  지난 번 atan 예제에서 hsb2rgb 함수에서
  파라미터를 정의할 때 'in vec3 c' 이런 식으로 작성을 했었지!

  이때 사용한 'in' 이라는 키워드가 qualifier의 한 종류임.
  qualifier에는 in / out / inout 총 3개가 있음.


  1. in
  기본적으로 함수에 인자를 전달할 시, 
  vec3 같은 값을 별도의 키워드 없이 전달하면
  결국에는 그거는 in vec3 형태로 전달한 것과 같음.

  여태까지 대부분의 예제에서 별도의 키워드없이 인자값을 전달했던 것이
  결국에는 다 앞에 in이 생략되어 있었다고 보면 됨.

  void plus(vec3 col) {
    col = col + .5;
  }

  근데 여기서 착각하기 쉬운 게,
  그러면 col값의 성분에 각각 0.5씩 더해주니까 회색이 찍혀야되는거 아닌가?
  하지만 아무런 변화가 없음.
  왜냐? in은 '깊은 복사'로 인자를 전달해주기 때문. (즉, 레퍼런스가 아닌, 'vec3 값 자체'를 복사해서 넘겨줌)

  왜냐면, in은 vec3 col의 실제 레퍼런스가 들어가는 게 아니라,
  col의 말 그대로 vec3 타입의 '데이터값'만 넘어가는 것이기 때문에,
  리턴값을 받아서 사용하는 것이 아닌 이상,
  plus 함수 내부에서 col에 어떤 연산을 해주던지 실제 vec3 col 에는 아무런 변화가 없음!


  2. out
  이거는 함수에 인자를 '얕은 복사' 하여 전달함.
  즉, 전달된 인자의 실제 값이 아닌 '레퍼런스'를 복사하여 전달함.

  void plus(out vec3 col) {
    col = col + .5;
  }
  
  따라서, 이 함수안에서 어떤 계산을 해주면
  실제로 vec col의 값이 변하면서 변경된 색상값이 캔버스에 찍히게 됨.


  3. inout
  얕은 복사(레퍼런스 복사)를 할 때 out보다는 보통은 inout을 많이 씀.
  그래서 아무 것도 리턴을 해주지 않더라도,
  vec3 col의 주소값이 전달이 되었기 때문에
  해당 인자를 이용해서 어떤 계산을 해주면 실제로 col 값이 바뀌게 됨.

  그럼 inout과 out의 차이는 무엇인가?

  inout은 인자로 넣어준 vec3 col이 기존에 갖고있던 실수값 데이터를 그대로 가지고 가지만,
  out은 인자로 넣어준 vec3 col의 실수값 데이터를 vec3(0.0)으로 초기화한 뒤에, 레퍼런스를 전달해 줌.
  그래서 out은 기존에 초기화 해두었던 인자의 값들이 전혀 쓸모없어짐.

  그런데 문제는, 내가 GLSL Editor랑 glslCanvas에서 모두 해본 결과
  inout이랑 out모두 이전에 초기화해둔 실수값들이 그대로 전달되어서 화면에 찍힘.

  강의 영상에서는 확실히 out을 사용하면 인자값이 초기화되는 것 같기는 한데...
  아마 shader 문법이 바뀐 걸수도 있고, GLSL Editor가 out 문법 관련 업데이트를 한 걸 수도 있을 것 같음.
  어쨋든 내용만 알고 있으면 될 것 같음.
*/

/*
  qualifier 를 자주 남발하는 것은 지양하는 것이 좋다고 함.
  특히, out같은 경우는 정말 가급적이면 쓰지 않는 게 좋다고 함.

  코드의 가독성이 떨어지기도 하고,
  코드를 유지보수 하기도 불편한 일이 발생하기 때문이라고 함.

  웬만하면 in qualifier 정도로도 충분히 작업이 가능하고,
  부득이한 경우 inout을 사용하는 게 좋다고 함.

  그래서 out이랑 inout이랑 결과가 같게 나오도록 수정이 된건가? 
*/