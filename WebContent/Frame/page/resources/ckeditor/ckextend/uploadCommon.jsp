<%@page import="com.amarsoft.awe.Configure"%>
<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<%@page import="com.amarsoft.biz.formatdoc.util.UploadManager"%>
<%
UploadManager.UPLOAD_PHYSICAL_PATH = Configure.getInstance(application).getConfigure("WorkDocSavePath")+"/Upload";
String url = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath();
UploadManager.UPLOAD_WEB_PATH = url+"/servlet/view/file?CompClientID="+request.getParameter("CompClientID")+"&filename="+UploadManager.UPLOAD_PHYSICAL_PATH;
%>