<%@page import="com.amarsoft.app.contentmanage.Content"%>
<%@page import="com.amarsoft.app.contentmanage.action.ContentManagerAction"%>
<%@page import="com.amarsoft.app.als.image.ImageAuthManage"%>
<%@ page contentType="text/html; charset=GBK"%>
<script type="text/javascript" src="<%=request.getContextPath()%>/ImageTrans/jquery-1.7.2.min.js"></script>
<%@ include file="/IncludeBeginMD.jsp"%>
<%
	//����������	,Ӱ�����ţ��ͻ��Ż�����ţ���Ӱ�����ͺ�
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	String sTypeNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("TypeNo"));
	//ֻ���ڴ�����ļ������в�����ViewTypeNo����������ݹ���	add by lyi 2014/06/03
	String sViewTypeNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ViewTypeNo"));
	if(sViewTypeNo == null) sViewTypeNo = "";
	String sServletPath = CurConfig.getConfigure("ServletPaht");
	String sOldObjectType = sObjectType;//����һ���ֶ����洢�ϵ�ObjectType
	if(sObjectType.equals("FileManageView")){//�ڴ����ļ������ҳ���д򿪵�
		if(sTypeNo.startsWith("1010") || sTypeNo.startsWith("1020")){//��������������ڵ����Ϳ�ͷ�ģ������������ΪCustomer
			sObjectType = "Customer";
		}else{
			sObjectType = "Image";
			
		}
	}

	ASResultSet rs= null;
	ASResultSet resultSet = null;
	String sRSObjectNo = "";
	if(sOldObjectType.equals("FileManageView") && sObjectType.equals("Image")){
		rs = Sqlca.getResultSet("select  SerialNo  from  Business_Apply where CustomerID='"+sObjectNo+"'");
		
		while (rs.next()){
			sRSObjectNo += rs.getString("SerialNo")+"','";
		}
		rs.getStatement().close();
		sRSObjectNo = "('"+sRSObjectNo.substring(0, sRSObjectNo.length()-2)+")";
		
		//���Ҷ�Ӧ��docId, �Ž�list
		resultSet= Sqlca.getResultSet(
				"select  documentId  from  ECM_PAGE where objectType='"+sObjectType+"' and objectNo in "+sRSObjectNo
				+" and typeNo='"+sTypeNo+"' and documentId is not null order by serialno"
		);
	}else{
		//���Ҷ�Ӧ��docId, �Ž�list
		resultSet= Sqlca.getResultSet(
				"select  documentId  from  ECM_PAGE where objectType='"+sObjectType+"' and objectNo='"+sObjectNo+"' and typeNo='"+sTypeNo
				+"' and documentId is not null order by serialno"
		);
	}


	ArrayList<String> list = new ArrayList<String>();
	while(resultSet.next()){
		list.add(resultSet.getString("documentId"));
	}
	resultSet.close();
	System.out.println("---------"+list);
	//����ͼ�б�html
	String htmlStr = "";
	//��������
	String sNewPath = "http://"+sServletPath;
	//���Ի���
	//String sNewPath = sWebRootPath;
	for(int i=0; i<list.size(); i++){
		Content content = ContentManagerAction.getContentManager().get(list.get(i));
		htmlStr = htmlStr+"<div class='thumbnail_unit'>"+
				"<div class='title'>��"+(i+1)+"ҳ</div>"+
		"<div class='info' style='display: none;'>"+(content==null?"":content.getDesc())+"</div>"+
				"<div class='content'><img style='width:206px ' src='"+sNewPath +"/servlet/ContentServlet?Id="+list.get(i)+"' ></img></div>"+ 
				"</div>";
	}
	
	%>
	
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<title>ͼƬ�任Ч��</title>
<link rel="stylesheet" type="text/css" href="<%=sWebRootPath%>/ImageTrans/img.css"/>
<script>
$(document).ready(function(){
	$('#idInitialSize').click(function(){
		var size = document.getElementById('img_size').innerHTML;
		var sizes = size.split('X');
		$('#idContainer img').css({'width':Number(sizes[0])*2,'height':Number(sizes[1])*2});
		
	});
	$('#thumbnail_img .content').click(function(){
		var unit =  $(this).parent();
		unit.siblings('.focus').removeClass('focus');
		unit.addClass('focus');
		src = $(this).find('img').attr('src');
		it.dispose();
		it = new ImageTrans( container, options );
		it.load(src);
		$('#idContainer_root .bar').html(unit.find('.title').html());
		$('#img_info').html(unit.find('.info').html());
		AddMouseMoveEvent();
	});
	AddMouseMoveEvent();
	function AddMouseMoveEvent(){
		var img =$('#idContainer img');
		var width = img[0].scrollWidth;
		var height = img[0].scrollHeight;
		document.getElementById('img_size').innerHTML = width+"X"+height;
		$('#idContainer img').bind('mousemove',function(e){
			var obj = $(this).offset();
			var x= e.clientX;
			var y= e.clientY;
			var left = obj.left;
			var top = obj.top;
			x= x - left;
			y= y - top  +(document.all?93:0);
			$('#size_x').html('X:'+x);
			$('#size_y').html('Y:'+y);
		});
	}
});
</script>
<script type="text/javascript" src="<%=sWebRootPath%>/ImageTrans/CJL.0.1.min.js"></script>
<script type="text/javascript" src="<%=sWebRootPath%>/ImageTrans/ImageTrans.js"></script>
</head>
<body>
<table style="height:100%;width:100%;border:0;" cellpadding="0">
<tr>
	<td colspan="2"><div id="menu"><div id="menu_2">
		<a id="idLeft"><span></span>��ת90��</a>
		<a id="idRight"><span></span>��ת90��</a>
		<a id="idVertical"><span></span>��ֱ��ת</a>
		<a id="idHorizontal"><span></span>ˮƽ��ת</a>
		<a id="idReset"><span></span>����</a>
<!--		<span id="idCanvas">ʹ��Canvas</span>-->
		<a id="idAutoFitWidth"><span></span>���ʿ��</a>
		<a id="idFullPage"><span></span>��ҳ��ʾ</a>
		<a id="idInitialSize"><span></span>ԭʼ��С</a>
		<!--<a id="idUp"><span></span>����</a>
		<a id="idDown"><span></span>����</a>
		<a id="idSetFirstPage"><span></span>���óɵ�һҳ</a>
		<a id="idSetLastPage"><span></span>���ó����һҳ</a>-->
	</div></div></td>
</tr>
<tr>
	<td style="width:200px;height:100%;"><div id="thumbnail">
		<table style="height:100%;width:100%;border:0;float:left;border:1px solid #C2C4CB;border-radius:3px 3px 0" cellpadding="0">
		<tr><td><div class="bar" style="color:#9EA1AE;font-weight:bold;padding-left:5px;">����ͼ�б�</div></td></tr>
		<tr><td style="height:100%;"><div style="height:100%;width:100%;min-height:450px;position:relative;">
			<div id="thumbnail_img"></div>
		</div></td></tr>
		</table>
	</div></td>
	
	<td style="height:100%;width:100%;"><div id="idContainer_root" style="position:relative;">
		<table style="height:100%;width:100%;border:0;float:left;border:1px solid #C2C4CB;border-radius:3px 3px 0" cellpadding="0">
			<tr><td><div class="bar">��1ҳ</div></td></tr>
			<tr><td style="height:100%;"><div id="idContainer"></div></td></tr>
		</table>
	</div></td>
</tr>
<tr>
	<td colspan="2">
	<div>
	<span>ͼƬ��Ϣ��<label id="img_info"></label></span>
	</div>
	<div id="bottom">
		<span>ͼ���С��<label id="img_size"></label></span>
		<span><label id="size_x">X:0</label>,<label id="size_y">Y:0</label></span>
	</div>
	</td>
</tr>
</table>
	
<script>
	$("#thumbnail_img").append("<%=htmlStr%>");

var container = $$("idContainer"), 
	src = '<%=list.size()>0? sNewPath +"/servlet/ContentServlet?Id="+list.get(0): sWebRootPath+"/ImageTrans/" %>',
	options = {
		onPreLoad: function(){ container.style.backgroundImage = ""; },
		onLoad: function(){ container.style.backgroundImage = ""; },
		onError: function(err){ container.style.backgroundImage = ""; }
	},
	it = new ImageTrans( container, options );
	it.load(src);
	//�����ͼƬ��Ĭ����ʾ��1ҳ��ͼƬ��Ϣ
	var firstImgInfo = $(".info:first");
	if(firstImgInfo.length>0){
		$("#img_info").html(firstImgInfo.html());
	}
	//��ֱ��ת
	$$("idVertical").onclick = function(){ it.vertical(); }
	//ˮƽ��ת
	$$("idHorizontal").onclick = function(){ it.horizontal(); }
	//����ת
	$$("idLeft").onclick = function(){ it.left(); }
	//����ת
	$$("idRight").onclick = function(){ it.right(); }
	//����
	$$("idReset").onclick = function(){ it.reset(); }
	
</script>	
</body>
</html>
<%@ include file="/IncludeEnd.jsp"%>