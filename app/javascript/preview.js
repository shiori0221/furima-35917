document.addEventListener('DOMContentLoaded', function(){
  if ( document.getElementById('item-image')){                //最初のinput要素のidを取得
    const imageList = document.getElementById('image-list');  //画像の一覧部分
    const itemImage = document.getElementById('item-image');


    //選択した画像を表示する関数
    const createImageHTML = (blob) => {                       //blobという値にHTML要素を作る

      const imageElement = document.createElement('div');     //<div id="img-set" class="image-element">
      imageElement.setAttribute('class', "image-element");
      let imageElementNum = document.querySelectorAll('.image-element').length;
      imageElement.setAttribute('id', `img-set-${imageElementNum}`);

      // 表示する画像を生成<img src class="image-preview">
      
      //ファイル選択ボタンを生成
      const inputHTML = document.createElement('input')        //<input name="item[images][]", id=`item-image-${imageElementNum}` type="file">
      inputHTML.setAttribute('name', 'item[images][]')
      inputHTML.setAttribute('id', `item-image-${imageElementNum}`)
      inputHTML.setAttribute('type', 'file')

      const button = document.createElement('input')
      button.setAttribute('type', 'button')
      button.setAttribute('value', '削除')
      button.onclick = pushBtn;
      button.style.display = "none";

      //生成したHTML要素をブラウザに表示させる //<div id="image-list"><div><input></input></div></div>
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
    
    itemImage.addEventListener('change', function(e){
      let file = e.target.files[0];
      let blob = window.URL.createObjectURL(file);
      createImageHTML(blob);
      const blobImage = document.createElement('img');
      blobImage.setAttribute('src', blob);
      blobImage.setAttribute('class', 'image-preview');
      const imgSet = document.querySelector('#img-set')
      imgSet.appendChild(button);
      imgSet.appendChild(blobImage);
      itemImage.style.display = "none";
    });
    function pushBtn(e) {
      e.target.closest('.image-element').remove();
    }
  };
});