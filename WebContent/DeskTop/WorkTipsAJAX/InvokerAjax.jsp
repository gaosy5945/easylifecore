<%@page import="com.amarsoft.dict.als.object.Item"%>
<%@page import="com.amarsoft.dict.als.manage.CodeManager"%>
<%@page contentType="text/html; charset=GBK"%><%@ include file="/IncludeBeginMDAJAX.jsp"%><%
	/*
	  author:syang 2009/10/20
		Content: ����̨��WorkTips������ʾAjaxչʾ�ܵ���ҳ��
		Input Param:
			Type:�������ͣ������꣬չ��ʱType ="1"��
	 */
	String sType = CurPage.getParameter("Type");
	String sItemNo = CurPage.getParameter("ItemNo");
	String sCodeNo = CurPage.getParameter("CodeNo");
	if(sType == null) sType = "0";
	if(sItemNo == null) throw new Exception("�봫����");
	if(sCodeNo == null) throw new Exception("�������");
	
	//ȡ���������
	Item[] codeDef = CodeManager.getItems(sCodeNo);
	String sURLName = "",urlParam = "",itemName = "";
	for(int i=0;i<codeDef.length;i++){
		Item vpItem = codeDef[i];
		String sCurItemNo = vpItem.getItemNo();
		itemName = vpItem.getItemName();
		if(sItemNo.equals(sCurItemNo)){	//�������봫��Ľ��бȽ�
			sURLName = vpItem.getItemAttribute();
			urlParam = vpItem.getAttribute1();
			break;
		}
	}
	//����ҳ��URL����Ϊ��
	if(sURLName == null || sURLName.length() == 0){
		throw new Exception("�����[PlantformTask]��ItemNo["+sItemNo+"],û������ItemAttribute�ֶε�ֵ");
	}
	
	
	if(urlParam == null) urlParam = "";
	response.sendRedirect(SpecialTools.amarsoft2Real(sWebRootPath+sURLName+"?Flag="+sType+"&"+urlParam+"&DisplayName=&CompClientID="+sCompClientID));
%><%@ include file="/IncludeEndAJAX.jsp"%>