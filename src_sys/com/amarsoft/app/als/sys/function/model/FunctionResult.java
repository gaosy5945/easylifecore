package com.amarsoft.app.als.sys.function.model;

import java.util.ArrayList;
import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.are.util.json.JSONDecoder;
import com.amarsoft.are.util.json.JSONElement;
import com.amarsoft.are.util.json.JSONEncoder;
import com.amarsoft.are.util.json.JSONObject;

/**
 * Function功能执行结果
 * <li>所有的执行结果均放在一个Map中，执行完成后可查询该类中数据。
 * @author Administrator
 *
 */
public class FunctionResult {
	public static final String SUCCESS_STATUS="000";
	
	private BusinessObject outputParameters;
	private List<String[]> messageList=new ArrayList<String[]>();
	
	private boolean finallyResult=true;
	
	/**
	 * 设置返回结果
	 * @param key 返回结果主键
	 * @param value 返回结果值
	 * @throws Exception 
	 */
	public final void setOutputParameter(String key,Object value) throws Exception{
		if(outputParameters==null){
			outputParameters=BusinessObject.createBusinessObject();
		}
		outputParameters.setAttributeValue(key, value);
	}
	
	/**
	 * 设置返回信息
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
	 * 获得执行结果的Map
	 * @return
	 */
	public BusinessObject getOutputParameters() {
		return outputParameters;
	}

	/**
	 * 执行结果叠加
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
			//此处需增加messageList的处理
		}
		String jsonValue= JSONEncoder.encode(result_J);
		return jsonValue;
	}

}
