<%@ page contentType="text/html; charset=GBK"%><%@
include file="/IncludeBegin.jsp"%><%
   String sSerialno = CurPage.getParameter("SerialNo");
	/* 
	ҳ��˵���� ͨ�����鶨������Tab���ҳ��ʾ��
	*/
	//����tab���飺
	//������0.�Ƿ���ʾ, 1.���⣬2.URL��3��������
	String sTabStrip[][] = {
		{"true", "��������", "/RiskClassify/ApplyInfo.jsp", "SerialNo="+sSerialno},
		{"true", "ҵ������", "/FrameCase/widget/dw/ExampleInfo.jsp", "ExampleId=2013012300000001"},
		{"true", "�ͻ���Ϣ", "/FrameCase/Layout/ExampleFrame.jsp", ""},
		{"true", "Ԥ����Ϣ", "/FrameCase/Layout/ExampleFrame.jsp", ""},
		{"true", "���ռ�¼", "/FrameCase/Layout/ExampleTab03.jsp", ""},
	};
	
	
%>

<%@ include file="/Resources/CodeParts/Tab01.jsp"%>
<%@ include file="/IncludeEnd.jsp"%>