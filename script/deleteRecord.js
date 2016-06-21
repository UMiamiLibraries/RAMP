/**
 * Created by jlittle on 6/6/16.
 */

function deleteRecord(eacId) {
    $(function() {
        $( ".delete-dialog" ).dialog({
            resizable: false,
            title: 'Delete this record',
            modal: true,
            buttons: {
                "Delete this record": function() {
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
                    $( this ).dialog( "close" );
                },
                Cancel: function() {
                    $( this ).dialog( "close" );
                }
            }
        });
    });
}