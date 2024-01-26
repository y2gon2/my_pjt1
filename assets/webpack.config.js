const path = require('path');

module.exports = {
  // 진입점 설정
  entry: './js/app.js', // 이 경로는 프로젝트에 맞게 조정해야 합니다

  // 출력 설정
  output: {
    path: path.resolve(__dirname, '../priv/static/assets'), // 출력 디렉토리
    filename: 'app.js', // 출력 파일명
  },

  // 모듈 설정
  module: {
    rules: [
      {
        test: /\.js$/, // .js 파일에 대한 처리
        exclude: /node_modules/, // node_modules 디렉토리 제외
        use: {
          loader: 'babel-loader', // Babel 로더 사용
          options: {
            presets: ['@babel/preset-env'], // Babel 프리셋 설정
          },
        },
      },
      // 추가적인 로더 설정(예: CSS, 이미지 파일 등)
    ],
  },
};