<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
 	/* 
 		ҳ��˵���� ͨ�����鶨������strip���ҳ��ʾ��
 	*/
 	//����strip���飺
 	//������0.�Ƿ���ʾ, 1.���⣬2.�߶�(px)��3.���ID(����Ϊ��)��4.URL��5����������6.�¼�
	String sStrips[][] = {
		{"true","����List" ,"500","","/FrameCase/widget/dw/ExampleList.jsp","",""},
		{"true","����Info" ,"500","","/FrameCase/widget/dw/ExampleInfo.jsp","ExampleId=2012081700000001",""},
	};
 	String sButtons[][] = {
		{"true","","Button","��ť1","��ť1","aaa()","","","","btn_icon_edit"},
		{"true","","Button","��ť2","��ť2","bbb()","","","","btn_icon_help"},
 	};
%>
<div style="z-index:9999;position:absolute;right:0;top:0;background:#fff;border:1px solid #aaa;font-size:12px;">
  	<pre>
  	
  	ͨ�����鶨������Strip���ҳ��ʾ��
	1. ����strip��ά���飺
	//������0.�Ƿ���ʾ, 1.���⣬2.�߶�(px)��3.���ID(����Ϊ��)��4.URL��5����������6.�¼�
	ʾ��: String sStrips[][] = {
		{"true","����List" ,"500","","/FrameCase/widget/dw/ExampleList.jsp","",""},
		{"true","����Info" ,"500","","/FrameCase/widget/dw/ExampleInfo.jsp","ExampleId=2012081700000001",""},
	};
	2. include �ļ� /Resources/CodeParts/Strip05.jsp
	</pre>
	<a style="position:absolute;top:5px;left:5px;" href="javascript:void(0);" onclick="$(this).parent().slideUp();">X</a>
</div>
<%@include file="/Resources/CodeParts/Strip05.jsp"%>
<script type="text/javascript">
	function aaa(){
		alert(1);
	}
	
	function bbb(){
		alert(2);
	}
</script>
<%@ include file="/IncludeEnd.jsp"%>