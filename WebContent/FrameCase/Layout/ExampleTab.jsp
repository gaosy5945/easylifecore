<%@ page contentType="text/html; charset=GBK"%><%@
include file="/IncludeBegin.jsp"%><%
	/* 
	ҳ��˵���� ͨ�����鶨������Tab���ҳ��ʾ��
	*/
	//����tab���飺
	//������0.�Ƿ���ʾ, 1.���⣬2.URL��3��������, 4. Strip�߶�(Ĭ��600px)��5. �Ƿ��йرհ�ť(Ĭ����) 6. �Ƿ񻺴�(Ĭ����)
	String sTabStrip[][] = {
		{"true", "List", "/FrameCase/widget/dw/ExampleList.jsp", ""},
		{"true", "Info", "/FrameCase/widget/dw/ExampleInfo.jsp", "ExampleId=2013012300000001", "", "true"},
		{"true", "Frame_1", "/FrameCase/Layout/ExampleFrame.jsp", ""},
		{"true", "Frame_2", "/FrameCase/Layout/ExampleFrame.jsp", ""},
		{"true", "Tab", "/FrameCase/Layout/ExampleTab03.jsp", ""},
		{"true", "Blank", "/Blank.jsp", ""},
	};

	CurPage.setAttribute("AfterTabHtml", ""+
		new Button("����", "", "newTab()").getHtmlText()+
		new Button("��ť", "", "alert('��㵽������')").getHtmlText());
%>
<div style="z-index:9999;position:absolute;right:0;bottom:0;background:#fff;border:1px solid #aaa;font-size:12px;">
  	<pre>
  	
  	ͨ�����鶨������Tab���ҳ��ʾ��
	1. ����tab��ά���飺
	������0.�Ƿ���ʾ, 1.���⣬2.URL��3��������
	ʾ��: String sTabStrip[][] = {
		{"true", "��ʾҳ�����", "/FrameCase/widget/dw/ExampleInfo.jsp", "ExampleId=2013012300000001"},
		};
	2. include �ļ� /Resources/CodeParts/Tab01.jsp
	</pre>
	<a style="position:absolute;top:5px;left:5px;" href="javascript:void(0);" onclick="$(this).parent().slideUp();">X</a>
</div>
<%@ include file="/Resources/CodeParts/Tab01.jsp"%>
<script type="text/javascript">
var n = 0;
function newTab(){
	addTabStripItem('��������'+(++n), '/AppMain/Blank.jsp', '');
}
function closeTab(sName, sFrameName){
	if(!frames[sFrameName]) return true;
	if($("body", frames[sFrameName].document).html()){
		return confirm("ҳ���Ѿ����أ��Ƿ�رգ�");
	}else{
		return true;
	}
}
</script>
<%@ include file="/IncludeEnd.jsp"%>