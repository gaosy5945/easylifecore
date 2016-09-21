<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%><%@ 	
 page import="com.amarsoft.are.jbo.*,com.amarsoft.biz.formatdoc.model.*" %><%
	//本案例实现获取格式化报告特定页面的数据对象的值
	
	String sDocID    = "D001";    		//调查报告文档编号-awe_erpt_record.docid(取值来自awe_erpt_catalog.docid)
	String sObjectNo = "2011062400000017"; 		//业务流水号-awe_erpt_record.objectno
	String sObjectType = "CreditApply"; 	//对象类型-awe_erpt_record.objecttype
	String sDirID = "00";//报文页面编号 awe_erpt_data.dirid(取值来自awe_erpt_def.dirid)
	//根据sDocID，sObjectNo，sObjectType，sDirID获取awe_erpt_data.serialno
	String sSerialNo = "";
	BizObjectManager manager = JBOFactory.getBizObjectManager("jbo.app.FORMATDOC_DATA");
	String sql = "select o.serialno from o,jbo.app.FORMATDOC_RECORD fr where o.relativeserialno=fr.serialno"
			+ " and o.dirid=:dirid and fr.objectno=:objectno and fr.objecttype=:objecttype and fr.docid=:docid";
	BizObjectQuery query = manager.createQuery(sql);
	query.setParameter("docid", sDocID);
	query.setParameter("objectno", sObjectNo);
	query.setParameter("objecttype", sObjectType);
	query.setParameter("dirid", sDirID);
	BizObject obj = query.getSingleResult(false);
	if(obj==null)
		throw new Exception("无效的参数");//查询不到awe_erpt_data.serialno
	else{
		//获得流水号
		sSerialNo = obj.getAttribute("serialno").getString();
		//还原数据,参数1：awe_erpt_data.serialno,参数2:固定为com.amarsoft,参数3:主要为获取图片等资源
		//根据awe_erpt_catalog和awe_erpt_def配置可知道还原成数据类为com.amarsoft.app.awe.framecase.formatdoc.template01.D001_00.java
		com.amarsoft.app.awe.framecase.formatdoc.template01.D001_00 fd = (com.amarsoft.app.awe.framecase.formatdoc.template01.D001_00)FormatDocHelp.getFDDataObject(sSerialNo, "com.amarsoft", new FormatDocConfig(request));
		//打印属性
		%>
		operateOrgName = <%=fd.getOperateOrgName()%><br>
		customerName = <%=fd.getCustomerName()%><br>
		...<br>
		<%
	}
	String sButtons[][] = {
		{"true","","Button","刷新","刷新","reloadSelf()","","","",""},//btn_icon_add
	};
%>
<%@ include file="/Frame/resources/include/ui/include_buttonset_dw.jspf"%>
<%@ include file="/IncludeEnd.jsp"%>