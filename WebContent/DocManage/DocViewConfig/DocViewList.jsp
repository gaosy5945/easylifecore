<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String sFolderId = (String)CurComp.getParameter("FolderId");
	if(null==sFolderId) sFolderId="";
	String sViewId = (String)CurComp.getParameter("ViewId");
	if(null==sViewId) sViewId="";
	
	ASObjectModel doTemp = new ASObjectModel("DocViewList");
	if(!"".equals(sFolderId) && null != sFolderId  && !"root".equals(sFolderId) &&  "root" != sFolderId){
		doTemp.setJboWhere(doTemp.getJboWhere()+" and parentFolder = '"+sFolderId+"'");
	} 
	
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setPageSize(20);
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{"true","All","Button","����","����","add()","","","","btn_icon_add",""},
			{"true","","Button","����","����","edit()","","","","btn_icon_detail",""},
			{"true","","Button","ɾ��","ɾ��","if(confirm('ȷʵҪɾ����?'))as_delete(0)","","","","btn_icon_delete",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	<%/*��¼��ѡ��ʱ�����¼�*/%>
	function mySelectRow(){
		 var sFolderId = getItemValue(0,getRow(0),'FOLDERID');
		 var sViewId = getItemValue(0,getRow(0),'VIEWID');
		if(typeof(sFolderId)=="undefined" || sFolderId.length==0) {
			AsControl.OpenView("/Blank.jsp","TextToShow=����ѡ����Ӧ����Ϣ!","rightdown","");
		}else{
			AsControl.OpenView("/DocManage/DocViewConfig/DocViewFileList.jsp","ViewId="+sViewId+"&FolderId="+sFolderId,"rightdown","");
		}
	}

</script>	
<script type="text/javascript">
	function add(){
		 var sViewId = getSerialNo("DOC_VIEW_CATALOG","VIEWID","");
		 var sFolderId  = getSerialNo("DOC_VIEW_CATALOG","FOLDERID","");
		 var sUrl = "/DocManage/DocViewConfig/DocViewInfo.jsp";
		 AsControl.OpenView(sUrl,"ViewId="+sViewId+"&FolderId="+sFolderId+"&ParentFolder="+"<%=sFolderId%>",'rightup','');
		 reloadSelf();
	}
	function edit(){
		 var sUrl = "/DocManage/DocViewConfig/DocViewInfo.jsp";
		 var sViewId = getItemValue(0,getRow(0),'VIEWID');
		 var sFolderId = getItemValue(0,getRow(0),'FOLDERID');
		 if(typeof(sFolderId)=="undefined" || sFolderId.length==0 ){
			alert("��������Ϊ�գ�");
			return ;
		 }
		AsControl.OpenView(sUrl,'ViewId=' + sViewId + "&FolderId=" + sFolderId ,'_self','');
		 reloadSelf();
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
