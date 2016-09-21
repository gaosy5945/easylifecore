package com.amarsoft.app.als.sys.function.model;

import java.util.ArrayList;
import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.are.util.json.JSONDecoder;
import com.amarsoft.are.util.json.JSONElement;
import com.amarsoft.are.util.json.JSONEncoder;
import com.amarsoft.are.util.json.JSONObject;

/**
 * Function����ִ�н��
 * <li>���е�ִ�н��������һ��Map�У�ִ����ɺ�ɲ�ѯ���������ݡ�
 * @author Administrator
 *
 */
public class FunctionResult {
	public static final String SUCCESS_STATUS="000";
	
	private BusinessObject outputParameters;
	private List<String[]> messageList=new ArrayList<String[]>();
	
	private boolean finallyResult=true;
	
	/**
	 * ���÷��ؽ��
	 * @param key ���ؽ������
	 * @param value ���ؽ��ֵ
	 * @throws Exception 
	 */
	public final void setOutputParameter(String key,Object value) throws Exception{
		if(outputParameters==null){
			outputParameters=BusinessObject.createBusinessObject();
		}
		outputParameters.setAttributeValue(key, value);
	}
	
	/**
	 * ���÷�����Ϣ
	 * @param messageCode 
	 * @param messageDesc
	 * @param functionItemID
	 */
	public final void setMessage(String messageLevel,String messageCode,String messageDesc,String functionItemID){
		String[] message = new String[4];
		message[0]= messageCode;
		message[1]= messageDesc;
		message[2]= functionItemID;
		message[3]= messageLevel;
		messageList.add(message);
	}

	/**
	 * ���ִ�н����Map
	 * @return
	 */
	public BusinessObject getOutputParameters() {
		return outputParameters;
	}

	/**
	 * ִ�н������
	 * @param functionResult
	 * @throws Exception 
	 */
	public final void append(FunctionResult functionResult) throws Exception {
		if(functionResult==null) return ;
		if(outputParameters==null) outputParameters=BusinessObject.createBusinessObject();
		if(functionResult.outputParameters!=null && functionResult.outputParameters.getAttributeIDArray()!=null){
			this.outputParameters.appendAttributes(functionResult.outputParameters);
		}
		this.messageList.addAll(functionResult.messageList);
		this.finallyResult = this.finallyResult&&functionResult.finallyResult;
	}
	
	public final String toJSONString() throws Exception{
		JSONObject result_J = JSONObject.createObject();
		
		result_J.appendElement(JSONElement.valueOf("SYS_FUNCTION_RUN_RESULT",this.finallyResult));
		result_J.appendElement(JSONElement.valueOf("SYS_FUNCTION_RUN_MESSGE",this.messageList));
		if(outputParameters!=null){
			result_J.appendElement(JSONElement.valueOf("SYS_FUNCTION_OUTPUTPARAMETERS",JSONDecoder.decode(outputParameters.toJSONString())));
			//�˴�������messageList�Ĵ���
		}
		String jsonValue= JSONEncoder.encode(result_J);
		return jsonValue;
	}

}
