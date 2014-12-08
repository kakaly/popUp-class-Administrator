

var executeSql = function(e){
    
        console.log("Click");
        
        var sql = $('#query').val();
    
        console.log(sql);
        
        
        if( sql!=null && sql!=""){
            var existingUrl = document.URL;
            var segments = existingUrl.split('/');
            var build = "";
            for( var i = 0; i < segments.length; ++i ){
                build = build + segments[i] + '/';
                if( segments[i] == "reports") break;
            }
            
            var space = sql.split( " ");
            sql = "";
            for( var i = 0; i < space.length; ++i){
                sql = sql + space[i];
                if( i != space.length - 1)
                    sql = sql + '-';
            }
            
            var target = build + sql;
            
            window.location = (target);
        }
    
}

window.onkeyup = function(e) {

    if( e.keyCode == 13 ){
        executeSql(e);
    }

}

$(function(){

    console.log("load");

    $('#queryButton').click( executeSql );
    
    $('#download').click( function(e){

        
    
        var csv = "data:text/csv;charset=utf-8,\n";
        
        $('tr').each( function(){
        
            $('td', this).each( function(){
            
                csv = csv + this.textContent + ',';
            
            });
            //remove latent comma
            csv = csv.substring(0, csv.length - 1);
        
            csv = csv + '\n';
        
        });
    
        //console.log(csv);
        
        //http://stackoverflow.com/questions/14964035/how-to-export-javascript-array-info-to-csv-on-client-side
        var encodedUri = encodeURI(csv);
        var link = document.createElement("a");
        link.setAttribute("href", encodedUri);
        link.setAttribute("download", "my_data.csv");

        link.click();
    
    });
    
});
