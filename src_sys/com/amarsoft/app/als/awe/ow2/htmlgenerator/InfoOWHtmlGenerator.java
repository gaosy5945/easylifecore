package com.amarsoft.app.als.awe.ow2.htmlgenerator;
import com.amarsoft.app.als.awe.ow2.processor.DataObjectQuerier;
import com.amarsoft.app.als.awe.ow2.processor.OWBusinessProcessor;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectHelper;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.base.util.ObjectWindowHelper;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.awe.dw.handler.BusinessProcessData;
import com.amarsoft.awe.dw.ui.actions.IDataAction;
import com.amarsoft.awe.dw.ui.htmlfactory.InfoHtmlWithASDataObjectGenerator;
import com.amarsoft.awe.dw.ui.info.DefaultAction;
import com.amarsoft.awe.dw.ui.invoke.GenHtmlInvoker;
import com.amarsoft.awe.dw.ui.invoke.GenHtmlInvokerFilter;
import com.amarsoft.awe.dw.ui.keyfilter.jsgenerate.IKeyFilterBuilder;
import com.amarsoft.awe.dw.ui.keyfilter.jsgenerate.KeyFilterBuilder;
import com.amarsoft.awe.dw.ui.util.Const;
import com.amarsoft.awe.dw.ui.validator.client.IVaildateJSCode;
import com.amarsoft.awe.dw.ui.validator.client.JQueryForm;
import com.amarsoft.awe.util.ObjectConverts;

public class InfoOWHtmlGenerator extends InfoHtmlWithASDataObjectGenerator{

	private BusinessObject businessObject;
	private JBOTransaction tx;

	public String getHtmlResult(String styleId) throws Exception {
		String formName = ObjectWindowHelper.getObjectWindowName(this.asObj);
		if(!formName.startsWith("myiframe")) formName="myiframe"+formName;
		if(formName==null||formName.length()==0) formName="myiframe0";
		
		GenHtmlInvoker invoker = new GenHtmlInvokerFilter();
		String html="";
		String scripthtml="";
		//��ʼ���ɴ���
		html += invoker.generate(asObj, styleId, data, inputStatus, false, webRootPath);
		
		//�༭���
		if(businessObject.getState()!=BizObject.STATE_NEW){
			html = html.replaceAll("\\{dwrowcount\\}", "1");
		}
		else
			html = html.replaceAll("\\{dwrowcount\\}", "0");
		
		//������֤�ű�
		IVaildateJSCode validCode = new JQueryForm(this.asObj.getDONO(),this.asObj.getValidateTagList());
		html += "\n<script> _user_validator["+ formName.substring(8) +"] = " + validCode.generate(webRootPath,formName,asObj.getValidateRules())+"\n";
		//���ɹؼ���Ч��
		IKeyFilterBuilder keyFilter = new KeyFilterBuilder();
		html +=keyFilter.getResult(Const.getDWControlPath(webRootPath) + "/AutoComplete.jsp",asObj.getDONO()) + "</script>";
		
		html = html.replaceAll("\\{SERIALIZED_ASD\\}", this.asObj.getSerializableName());
		html = html.replaceAll("\\{SERIALIZED_JBO\\}", ObjectConverts.getString(businessObject));
		
		//�����ֶ���js����
		String[] displayFieldArray = invoker.getDisplayFields();
		StringBuffer displayFields = new StringBuffer();
		if(displayFieldArray!=null){
			for(int i=0;i<displayFieldArray.length;i++){
				displayFields.append(",'" + displayFieldArray[i] + "'");
			}
		}
		
		scripthtml += "\n<script>DisplayFields["+formName.substring(8)+"] = ["+ displayFields.substring(1) +"];\nDisplayDONO='"+ asObj.getDONO() +"';\n</script>";
		//JBO���л�
		scripthtml += "\n<script>\n";
		scripthtml += "\nif(typeof(nfilterValues)==\"undefined\") filterValues={};\n";
		scripthtml += "\n filterValues["+formName+"]=new Array();\n";
		scripthtml +="if(typeof(ALSObjectWindowFunctions)==\"undefined\" || ALSObjectWindowFunctions.length==0){ALSObjectWindowFunctions={};ALSObjectWindowFunctions.objectWindowMetaData=[];ALSObjectWindowFunctions.ObjectWindowData=[];}";
		scripthtml += "\n ALSObjectWindowFunctions.objectWindowMetaData["+formName.substring(8)+"] = "+ObjectWindowHelper.getDWMetaJSONString(asObj)+";\n";
		scripthtml += "\n ALSObjectWindowFunctions.ObjectWindowData["+formName.substring(8)+"] = [];\n";
		scripthtml += "\n ALSObjectWindowFunctions.ObjectWindowData["+formName.substring(8)+"][0] ="+ ObjectWindowHelper.generateClientObjectData(asObj,businessObject) +";\n";
		if(!StringX.isEmpty(this.asObj.getDONO()))scripthtml += "DisplayDONO='"+this.asObj.getDONO()+"';";
		scripthtml += "\n</script>\n";
		//���´���������ɣ��Լ���Info��List������һ��ҳ����
		scripthtml += "<script> i=DZ.length;\r\n DZ[i]=new Array();\r\n if(typeof(aDWfilterTitles) != \"undefined\") {aDWfilterTitles[i]= new Array();}\r\n </script>";
		
		return scripthtml+"\n"+html;
	}

	public final void run(BusinessProcessData bpData) throws Exception{
		OWBusinessProcessor businessProcess = OWBusinessProcessor.createBusinessProcess(request, asObj, BusinessObjectManager.createBusinessObjectManager(tx));
		DataObjectQuerier querier = businessProcess.getQuerier();
		querier.query(businessProcess);
		BusinessObject[] businessObjectArray = querier.getData(0, 10);
		if(businessObjectArray==null||businessObjectArray.length==0){//���û���ҵ����ʵļ�¼���Զ�����һ����¼
			businessObject = businessProcess.getCreator().newObject(businessProcess);
		}
		else if(businessObjectArray.length>1){
			throw new Exception("Datawindow={"+asObj.getDONO()+"}��ѯ������ڶ�������ȷ��ģ�������Ƿ���ȷ��");
		}
		else this.businessObject=businessObjectArray[0];
		this.data=BusinessObjectHelper.convertToHashtable(this.businessObject);
	}
	
}
