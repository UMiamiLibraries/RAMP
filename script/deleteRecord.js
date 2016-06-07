/**
 * Created by jlittle on 6/6/16.
 */

function deleteRecord(eacId) {
    $.post('ajax/delete_record.php',{"eac_id":eacId}, function(res) {

    }).done(function(res){
        console.log(res);
        if(res.success == true) {
            console.log(res.status);
            $('#'+eacId).remove();
        }
        if (res.success == false) {

            console.log(res.status);
        }
    });
}