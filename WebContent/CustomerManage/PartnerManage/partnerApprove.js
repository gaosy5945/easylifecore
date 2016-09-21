   /*~[Describe=��������;InputParam=��;OutPutParam=��;]~*/
    function viewTab()
    {
    	var serialNo = getItemValue(0,getRow(0),"ObjectNo");
    	var customerID = getItemValue(0,getRow(0),"CustomerID");
    	var ProjectType = getItemValue(0,getRow(0),"ProjectType");
    	 if (typeof(serialNo)=="undefined" || serialNo.length==0){
             alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
             return;
         }
    	//������ҳ��
    	AsCredit.openFunction("ProjectApplyView","CustomerID="+customerID+"&SerialNo="+serialNo+"&ProjectType="+ProjectType+"&RightType=ReadOnly","");
    	reloadSelf();  
    }   
    
    /*~[Describe=�鿴�������;InputParam=��;OutPutParam=��;]~*/
    function viewOpinions() 
    {
        //����������͡�������ˮ�š����̱�š��׶α��
        sObjectType = getItemValue(0,getRow(),"ObjectType");
        sObjectNo = getItemValue(0,getRow(),"ObjectNo");
        sFlowNo = getItemValue(0,getRow(),"FlowNo");
        sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
        if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
        {
            alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
            return;
        }
        popComp("","/Common/WorkFlow/ViewFlowOpinions.jsp","FlowNo="+sFlowNo+"&PhaseNo="+sPhaseNo+"&ObjectType="+sObjectType+"&ObjectNo="+sObjectNo,"");
    }
    /*~[Describe=ǩ�����;InputParam=��;OutPutParam=��;]~*/
    function signOpinion()
    {
        //����������͡�������ˮ�š����̱�š��׶α��
        sObjectType = getItemValue(0,getRow(),"ObjectType");
        sObjectNo = getItemValue(0,getRow(),"ObjectNo");
        sFlowNo = getItemValue(0,getRow(),"FlowNo");
        sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
        if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
        {
            alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
            return;
        }

        //��ȡ������ˮ��
        //sTaskNo=RunMethod("WorkFlowEngine","GetUnfinishedTaskNo",sObjectType+","+sObjectNo+","+sFlowNo+","+sPhaseNo+","+"<%=CurUser.getUserID()%>");
        sTaskNo = getItemValue(0,getRow(),"SerialNo");
        if(typeof(sTaskNo)=="undefined" || sTaskNo.length==0) {
            alert(getBusinessMessage('500'));//����������Ӧ���������񲻴��ڣ���˶ԣ�
            return;
        }
        
        sCompID = "";
        sCompURL = "/Common/WorkFlow/SignTaskOpinionInfo.jsp";
     	var returnValue =  popComp(sCompID,sCompURL,"TaskNo="+sTaskNo+"&ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&PhaseNo="+sPhaseNo,"dialogWidth=50;dialogHeight=37;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
     	if(returnValue=="success") doSubmit();//����ֵΪ��success�����򵯳��ύҳ��
    }
    
    /*~[Describe=�ύ����;InputParam=��;OutPutParam=��;]~*/
    function doSubmit()
    {
        //����������͡�������ˮ�š��׶α��
        sObjectType = getItemValue(0,getRow(),"ObjectType");
        sObjectNo = getItemValue(0,getRow(),"ObjectNo");
        sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
        
        //���������ˮ��
        sSerialNo = getItemValue(0,getRow(),"SerialNo");
        if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
        {
            alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
            return;
        }
        
        //����ҵ���Ƿ��Ѿ��ύ�ˣ�����û��򿪶����������ظ������������Ĵ���
        sEndTime=RunMethod("WorkFlowEngine","GetEndTime",sSerialNo);
        if((typeof(sEndTime)=="undefined" || sEndTime.trim().length >0) && sEndTime != "Null") {
            alert("��ҵ����׶������Ѿ��ύ�������ٴ��ύ��");//��ҵ����׶������Ѿ��ύ�������ٴ��ύ��
            reloadSelf();
            return;
        }

        //����Ƿ�ǩ�����
        sReturn = PopPageAjax("/Common/WorkFlow/CheckOpinionActionAjax.jsp?SerialNo="+sSerialNo,"","dialogWidth=0;dialogHeight=0;minimize:yes");
        if(typeof(sReturn)=="undefined" || sReturn.length==0) {
            alert(getBusinessMessage('501'));//��ҵ��δǩ�����,�����ύ,����ǩ�������
            return;
        }

        //���������ύѡ�񴰿�
        sPhaseInfo = PopPage("/Common/WorkFlow/SubmitDialog.jsp?SerialNo="+sSerialNo,"","dialogWidth=580px;dialogHeight=420px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
        if(typeof(sPhaseInfo)=="undefined" || sPhaseInfo=="" || sPhaseInfo==null || sPhaseInfo=="null" || sPhaseInfo=="_CANCEL_") return;
		else if (sPhaseInfo == "Success"){
            alert(getHtmlMessage('18'));//�ύ�ɹ���
            //ˢ�¼�����ҳ��
            OpenComp("ApproveMain","/Common/WorkFlow/PartnerProjectFlow/ApproveMain.jsp","ComponentName=������Ŀ����&ComponentType=MainWindow&ApproveType=<%=sApproveType%>","_top","");
        }else if (sPhaseInfo == "Failure"){
            alert(getHtmlMessage('9'));//�ύʧ�ܣ�
            return;
        }else{
            sPhaseInfo = PopPage("/Common/WorkFlow/SubmitDialogSecond.jsp?SerialNo="+sSerialNo+"&PhaseOpinion1="+sPhaseInfo,"","dialogWidth=34;dialogHeight=22;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
            //����ύ�ɹ�����ˢ��ҳ��
            if (sPhaseInfo == "Success"){
                alert(getHtmlMessage('18'));//�ύ�ɹ���
                //ˢ�¼�����ҳ��
                OpenComp("ApproveMain","./ApproveMain.jsp","ComponentName=����ҵ������&ComponentType=MainWindow&ApproveType=<%=sApproveType%>","_top","");
            }else if (sPhaseInfo == "Failure"){
                alert(getHtmlMessage('9'));//�ύʧ�ܣ�
                return;
            }
        }
    }