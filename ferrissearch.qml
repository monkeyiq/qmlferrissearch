
import QtQuick 1.1
import QtWebKit 1.0
import "script"
import "script/ajaxmee.js"    as Ajaxmee
import "script/array2json.js" as ArrayToJson
import "script/strftime.js"   as Strftime
import "script/storage.js"    as Storage

Rectangle {
    id: container
    width: 854; height: 480
    color: "#222222"
    z: -100 

    Rectangle {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter:   parent.verticalCenter
	id: config
	width: 854; height: 480
	visible: false
	color: "#aaaaaa"
	opacity: 1
	z: 200

	MouseArea { anchors.fill:parent; }
	Column {
	    spacing: 15
            anchors.horizontalCenter: parent.horizontalCenter
	    Grid {
		columns: 2
		spacing: 10
		Text { 
		    text: "REST URL" 
		    font.pixelSize: 30
		    horizontalAlignment: Text.AlignRight
		}
		TextInput { 
		    id: restURL
		    text: "http://" 
		    font.pixelSize: 30
		}
		Text { 
		    text: "EA Index path" 
		    font.pixelSize: 30
		    horizontalAlignment: Text.AlignRight
		}
		TextInput { 
		    id: eaindexpath
		    text: "http://" 
		    font.pixelSize: 30
		}
	    }
            TextButton {
                anchors.horizontalCenter: parent.horizontalCenter
		width: 200
		height: 40
		text: "Done"
		onClicked: { 
		    config.visible = false; 
		    if( restURL.text.substring(0, 7) != "http://"
			&& restURL.text.substring(0, 7) != "https:/" )
		    {
			restURL.text = "http://" + restURL.text;
		    }
		    if( eaindexpath.text == "" )
			eaindexpath.text = "~/.ferris/ea-index";
		    Storage.setSetting( "resturl",     restURL.text );
		    Storage.setSetting( "eaindexpath", eaindexpath.text );
		}
	    }
	}
    }


    Text {
	id: searchTypePredPrefix
	visible: false
	text: "(url=~";
    }

    Rectangle {
	id: busycontainer
	width: 100; height: 100
	x: 300; y:190; z:200;
	color: "#222222"
	visible : busy.on;

	BusyIndicator {
	    anchors.fill: parent
	    id: busy
	    on: false
	}
    }

    Rectangle {
	id: qtcontainer
	visible: false
	width: 854; height: 480
	color: "#332222"
	x:0; y:0; z: 100
	anchors.margins: 20
	Grid {            
	    // anchors.top: parent.top
	    // anchors.left: parent.left
	    anchors.fill: parent
            anchors.topMargin: 10
            anchors.leftMargin: 10
	    columns: 2
	    spacing: 30
	    TextButton {
		width: 400
		height: 40
		text : "Regex on URL"
		onClicked: { 
		    statuscount.text = "";
		    resultsModel.clear();
		    searchTypePredPrefix.text = "(url=~";
		    query.text = "      ";
		    queryType.text = text;
		    qtcontainer.visible = false; 
		}		
	    }
	    TextButton {
		width: 400
		height: 40
		text : "Query on Text Content"
		onClicked: { 
		    statuscount.text = "";
		    resultsModel.clear();
		    searchTypePredPrefix.text = "(ferris-ftx=~";
		    query.text = "      ";
		    queryType.text = text;
		    qtcontainer.visible = false; 
		}		
	    }
	    TextButton {
		height: 40
		text : "Modified more recently than this"
		onClicked: { 
		    statuscount.text = "";
		    resultsModel.clear();
		    searchTypePredPrefix.text = "(mtime>=";
		    query.text = "begin this ";
		    queryType.text = text;
		    qtcontainer.visible = false; 
		    query.openSoftwareInputPanel();
		}		
	    }
	    TextButton {
		height: 40
		text : "Modified more recently than last"
		onClicked: { 
		    statuscount.text = "";
		    resultsModel.clear();
		    searchTypePredPrefix.text = "(mtime>=";
		    query.text = "begin last ";
		    queryType.text = text;
		    qtcontainer.visible = false; 
		    query.openSoftwareInputPanel();
		}		
	    }
	    TextButton {
		height: 40
		text : "Modified >= X months ago"
		onClicked: { 
		    statuscount.text = "";
		    resultsModel.clear();
		    searchTypePredPrefix.text = "(mtime>=";
		    query.text = "     months ago";
		    queryType.text = text;
		    qtcontainer.visible = false; 
		    query.openSoftwareInputPanel();
		}		
	    }
	}
    }

    ListModel {
        id: resultsModel
        ListElement {
            name: "Debian.iso"; size: 43284423423; mtime_display: "today"; url: "http://debian.org/image.iso"; index_docid: 1;
	}
        ListElement {
            name: "Save Ferris.jpg"; size: 3534543; mtime_display: "tomorrow"; url: "http://www.libferris.com/this/rocks"; index_docid : 3;
	}
    }
    Component {
        id: listDelegate
        
        Item {
            id: delegateItem
            width: listView.width; height: 72
            clip: true

            Row {
		id: r
                anchors.verticalCenter: parent.verticalCenter
                spacing: 10

		Grid {
		    columns: 3
		    spacing: 10
		    Column {
			width: 64;
			Image {
			    width: 64; height: 64;
			    source: "images/play.png"
			    MouseArea { anchors.fill:parent; onClicked: viewFile(index) }
			}
		    }
		    Column {
			Row {
			    Text { 
				width: 70
				text: formatsz( size )
				font.pixelSize: 15
				color: "white"
			    }
			    Text { 
				width: 70
				text: { return resultsModel.get(index).index_docid; }
				font.pixelSize: 15
				color: "#aa7777"
			    }
			}
			Text { 
			    width: 110
			    text: mtime_display
			    font.pixelSize: 15
			    color: "white"
			}
		    }
		    Column {
			Text { 
			    text: url
			    font.pixelSize: 15
			    color: "white"
			}
			Text { 
			    text: { return resultsModel.get(index).annotation; }
			    font.pixelSize: 20
			    font.bold: true
			    color: "white"
			}
		    }

		}
	    }
	}
    }

    Rectangle {
	x: 0
	y: 0
	width: 854
	height: 40
	z: 1
	gradient: Gradient {
	    GradientStop { position: 0.0;  color: "#111111" }
	    GradientStop { position: 0.6;  color: "#222222" }
	    GradientStop { position: 1.0;  color: "#222222" }
	}
    }

    Column {
	id: searchcol
	z: 20
	Row {
	    z: 20
	    Text { 
		z: 20
		text: "Search:" 
		color: "#ddddaa"
		font.pixelSize: 30
	    }
	    TextInput { 
		id: query
		z: 20
		width: 400
		color: "#ddddaa"
		text: "           " 
		font.pixelSize: 30
		height: 40
		onAccepted: { 
		    closeSoftwareInputPanel(); 
		    listView.forceActiveFocus(); 
		    busy.on = true; 
		    runQuery();}
	    }
	    

	    TextButton {
		id : queryType
		text : "Regex on URL"
		width: 300
		height: 40
		onClicked: { 
		    qtcontainer.visible = true; 
		}		
	    }
	}
    }


    ListView {
        id: listView
	z: 0
	y: 60; x: 20
	width: 814; height: 350
        model: resultsModel
        delegate: listDelegate
    }

    Rectangle {
	x: 0
	y: 430
	width: 854
	height: 50
	z: 1
	gradient: Gradient {
	    GradientStop { position: 0.0;  color: "#222222" }
	    GradientStop { position: 0.2;  color: "#222222" }
	    GradientStop { position: 1.0;  color: "#111111" }
	}
    }

    Row {
        anchors { left: parent.left; bottom: parent.bottom; margins: 20 }
        spacing: 10
	z: 20
	Text { 
	    id: statuscount
	    text: "        " 
	    color: "#ddddaa"
	    font.pixelSize: 22
	}

	Text { 
	    id: status
	    text: "" 
	    color: "#aaaaaa"
	    font.pixelSize: 22
//	    anchors.fill : parent
//	    anchors.right : parent
	}
        TextButton {
	    height: 40
	    width:  130
	    text: "Config"
	    onClicked: config.visible = true	    
	}


	Timer {
	    id: twosecspin
            interval: 2000; running: false; repeat: false
            onTriggered: { busy.on = false; }
	}
    }

    function runQuery()
    {
	var t = query.text;
	t = t.replace(/^[ ]*/g,'');
	t = t.replace(/[ ]*$/g,'');
	t = searchTypePredPrefix.text + t + ")"
//	query.text = t;
	console.log("q:" + t);

	var earl = restURL.text + "?" + "method=eaquery";
	earl = earl + "&q=" + t;
	earl = earl + "&limit=" + "500";
//	earl = earl + "&eanames=name,url,size,mtime-display,index:docid,annotation,atime";
	earl = earl + "&eanames=name,url,size,mtime-display,index:docid,index:annotation,atime";
	earl = earl + "&eaindexpath=" + eaindexpath.text;
	earl = earl + "&stub=" + "1";
	console.log("earl:" + earl);

	var data = {};
	console.log('calling data:' + data)
	Ajaxmee.ajaxmee('GET', earl, data,
		function(data) {
		    busy.on = false;
		    console.log('ok', 'data:' + data)
		    var x = JSON.parse(data);
		    resultsModel.clear();

		    var resultCount = 0;
		    var id;
		    for( id in x ) 
		    {
//			console.log( "looping... " + id );
			var dd = x[ id ];
//			console.log( "looping... sz3: " + dd["size"] );
			
			var row = {};
			row[ "objid" ] = id;
			row[ "name" ] = "unnamed";
			row[ "size" ] = "0";
			row[ "mtime" ] = "now";
			var k;
			for( k in dd ) 
			{
    			    row[ k ] = dd[ k ];
//			    console.log( "looping... k:" + k + " v:" + dd[k] );
			}
			resultsModel.append( row );
			++resultCount;
		    }
		    statusToNow();
		    statuscount.text = "" + resultCount + " Results";
		},
		function(status, statusText) {
		    busy.on = false;
		    console.log('error', status, statusText)
		})

    }    

    function viewFile( x ) 
    {
	var earl  = resultsModel.get(x).url;
	var docid = resultsModel.get(x).index_docid;
	console.log( "play docid:" + docid );
	console.log( "play   URL:" + earl );
	
	earl = restURL.text + "?" + "method=get-doc-by-ea-index-docid";
	earl = earl + "&docid=" + docid;
	earl = earl + "&eaindexpath=" + eaindexpath.text;
	earl = earl + "&stub=" + "1";
	console.log( "play rest.URL -->:" + earl + ":<--" );
	Qt.openUrlExternally( earl );
	busy.on = true;
	twosecspin.running = true;
    }

    function statusToNow() 
    {
	var data;
	status.text = "Updated at:" + formatDate( new Date() );
    }


    function startupFunction() 
    {
	status.text = "started";
	statusToNow();

        Storage.initialize();
	restURL.text     = Storage.getSetting( "resturl" );
	eaindexpath.text = Storage.getSetting( "eaindexpath" );
    }
    Component.onCompleted: startupFunction();



    function formatsz( sz ) {
	if( !sz ) { 
	    return " ";
	}
	if( sz > 1024 * 1024 * 1024 ) {
	    return Number( (sz / (1024 * 1024 * 1024))).toFixed(1) + "g";
	}
	if( sz > 1024 * 1024 ) {
	    return Number( (sz / (1024 * 1024))).toFixed(1) + "m";
	}
	if( sz > 1024 ) {
	    return Number( (sz / 1024)).toFixed(1) + "k";
	}
	return Number( sz ).toFixed(0) + "b";
    }

    function formatDate( d ) {
	var extension = "th ";
	var day = d.getDate();
	if( day == 1 || day == 11 || day == 21 || day == 31 )
	    extension = "st ";
	if( day == 2 || day == 12 || day == 22 )
	    extension = "nd ";
	if( day == 3 || day == 13 || day == 23 )
	    extension = "rd ";
	var dateStr = padStr(d.getDate()) + "th "
            + padStr(d.getHours()) + ":"
            + padStr(d.getMinutes());
	return dateStr;
    }

    function padStr(i) {
	return (i < 10) ? "0" + i : "" + i;
    }
}

