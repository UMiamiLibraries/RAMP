/**
 * Created by jlittle on 6/6/16.
 */

function deleteRecord(eacId) {
    $.post('ajax/delete_record.php',{"eac_id":eacId}, function() {

    }).done(function(res){
        if(res.status === true) {
            console.log(res.status);
        }
        if (res.status === false) {
            console.log(res.status);
        }
    });
}