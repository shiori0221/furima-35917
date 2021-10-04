document.addEventListener('DOMContentLoaded', function(){
  if ( document.getElementById('item-image')){                //最初のinput要素のidを取得
    const imageList = document.getElementById('image-list');  //画像の一覧部分
    const itemImage = document.getElementById('item-image');
    const imgSet = document.querySelector('#img-set');


    //選択した画像を表示する関数
    const createImageHTML = (blob) => {                       //blobという値にHTML要素を作る
      const imageElement = document.createElement('div'); 
      imageElement.setAttribute('class', "image-element");
      let imageElementNum = document.querySelectorAll('.image-element').length;
      imageElement.setAttribute('id', `img-set-${imageElementNum}`);
      
      //ファイル選択ボタンを生成
      const inputHTML = document.createElement('input')
      inputHTML.setAttribute('name', 'item[images][]')
      inputHTML.setAttribute('id', `item-image-${imageElementNum}`)
      inputHTML.setAttribute('type', 'file')

      //削除ボタン生成
      const button = document.createElement('input')
      button.setAttribute('type', 'button')
      button.setAttribute('value', '削除')
      button.onclick = pushBtn;
      button.style.display = "none";

      //生成したHTML要素をブラウザに表示させる
      imageElement.appendChild(inputHTML);
      imageElement.appendChild(button);
      imageList.appendChild(imageElement);

      //2枚目以降の画像にも発火<input>が変わったら
      inputHTML.addEventListener('change', (e) => {
        file = e.target.files[0];                              //画像情報を変数fileに格納
        blob = window.URL.createObjectURL(file);               //取得した画像情報のURLを作成
        createImageHTML(blob);                               //選択した画像を表示する
        const blobImage = document.createElement('img');
        blobImage.setAttribute('src', blob);
        blobImage.setAttribute('class', 'image-preview');
        imageElement.appendChild(blobImage);
        inputHTML.style.display = "none";
        button.style.display = "block";
      })
    };

    //削除ボタンの生成
    const button = document.createElement('input')
    button.setAttribute('type', 'button')
    button.setAttribute('value', '削除')
    button.onclick = pushBtn;
    button.style.display = "block"
    

    //最初のinput要素が変わったら
    itemImage.addEventListener('change', function(e){
      let file = e.target.files[0];
      let blob = window.URL.createObjectURL(file);
      createImageHTML(blob);
      const blobImage = document.createElement('img');
      blobImage.setAttribute('src', blob);
      blobImage.setAttribute('class', 'image-preview');
      imgSet.appendChild(button);
      imgSet.appendChild(blobImage);
      itemImage.style.display = "none";
    });

    //削除ボタンを押したらそれを含む親要素ごと削除
    function pushBtn(e) {
      e.target.closest('.image-element').remove();
    }
  };
});