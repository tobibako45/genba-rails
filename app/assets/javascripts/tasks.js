// 普通に書いたらこれ
// window.onload = function () {
//     document.querySelectorAll('td').forEach(function (td) {
//
//         td.addEventListener('mouseover', function (e) {
//             e.currentTarget.style.backgroundColor = '#eff';
//         });
//
//         td.addEventListener('mouseout', function (e) {
//             e.currentTarget.style.backgroundColor = '';
//         });
//     });
// }

// railsアプリケーションはデフォルトでTurbolinks機能を有効だからコレ
document.addEventListener('turbolinks:load', function () {

    document.querySelectorAll('td').forEach(function (td) {
        td.addEventListener('mouseover', function (e) {
            e.currentTarget.style.backgroundColor = '#eff';
        });
        td.addEventListener('mouseout', function (e) {
            e.currentTarget.style.backgroundColor = '';
        });
    });

    // railsは、remote: trueをつけたa要素に対して、Ajax通信が成功したときにajax:successというイベントを発行してくれます。
    // ajax:successイベントに対応する処理を定義
    // document.querySelectorAll('.delete').forEach(function (a) {
    //     a.addEventListener('ajax:success', function () {
    //         var td = a.parentNode;
    //         var tr = td.parentNode;
    //         tr.style.display = 'none';
    //     });
    // });


    // ↑ クライアント側でイベントハンドラの処理を走らせる必要がないため、コメントアウト
});
