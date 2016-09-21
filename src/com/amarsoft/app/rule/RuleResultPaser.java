package com.amarsoft.app.rule;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.util.ASValuePool;
import com.amarsoft.are.util.Arith;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.core.json.JSONArray;
import com.amarsoft.core.json.JSONException;
import com.amarsoft.core.json.JSONObject;
import com.amarsoft.core.object.ResultObject;
import com.amarsoft.core.util.CommonUtil;

public class RuleResultPaser {
	String result;
	ResultObject ro;
	
	public RuleResultPaser(String resultString) throws Exception{
		this.result = resultString;
		this.ro = new ResultObject(resultString);
	}
	
	public RuleResultPaser(ResultObject resultObj) throws Exception{
		this.result = resultObj.toString();
		this.ro = resultObj;
	}
	
	public ASValuePool paseResult() throws Exception {
		ASValuePool result = new ASValuePool();
		
		JSONObject obj = null;
		try{
			obj = (JSONObject) ro.oJSON.get("CALLRULES");
		}catch(Exception e){
			
		}
		if(obj != null){
			ASValuePool callRules = new ASValuePool();
			//System.out.println(obj);
			for(Iterator it = obj.keys();it.hasNext();){
				ASValuePool pool = new ASValuePool();
				String key = (String) it.next();
				String seq = key.split(" ")[0];
				String content = key.split(" ")[1];
				String ruleType = content.substring(1,content.indexOf("]"));
				String ruleID = content.substring(content.indexOf("]")+1);
				JSONObject value = null;
				try{
					value = obj.getJSONObject(key);
				}catch(JSONException e){
					value = new JSONObject("{}");
				}
				//System.out.println(key+"    "+value);
				String returnValue = CommonUtil.getNodeValue(value,"RETURNVALUE","");
				String returnMessage = CommonUtil.getNodeValue(value,"RETURNMESSAGE","");
				String returnWeight = CommonUtil.getNodeValue(value,"RETURNWEIGHT","");
				String status = CommonUtil.getNodeValue(value,"STATUS","");
				String score = CommonUtil.getNodeValue(value,"分值","");
				String weight = CommonUtil.getNodeValue(value,"权重","");
				
				//System.out.println(ruleType+"/"+ruleID+"/"+returnValue+"/"+returnMessage+"/"+returnWeight);
				pool.setAttribute("Seq", seq);
				pool.setAttribute("RuleType", ruleType);
				pool.setAttribute("RuleID", ruleID);
				pool.setAttribute("ReturnValue", returnValue);
				pool.setAttribute("ReturnMessage", returnMessage);
				pool.setAttribute("ReturnWeight", returnWeight);
				pool.setAttribute("Status", status);
				pool.setAttribute("Score", score);
				pool.setAttribute("Weight", weight);
				
				callRules.setAttribute(seq, pool);
			}
			result.setAttribute("CALLRULES", callRules);
		}
		obj = (JSONObject) ro.oJSON.get("RESULTS");
		ASValuePool results = new ASValuePool();
		String status = CommonUtil.getNodeValue(obj,"STATUS","");
		results.setAttribute("Status", status);
		result.setAttribute("RESULTS", results);
		
		obj = (JSONObject) ro.oJSON.get("RETURNS");
		//System.out.println(obj);
		ASValuePool returns = new ASValuePool();
		result.setAttribute("RETURNS", parseJSON(obj));
		//String status = CommonUtil.getNodeValue(obj,"STATUS","");
		//results.setAttribute("Status", status);
		return result;
	}
	
	public ASValuePool paseReturn() throws Exception {
		//JSONObject obj = (JSONObject) ro.oJSON.get("RETURNS");
		return parseJSON(ro.oJSON);
	}
	
	public void paseResult(ASValuePool result,HashMap<String,String> returns,String keyName) throws Exception{
		boolean isPool = true;
		for(int i = 0;i < result.getKeys().length;i++){
			String key = (String)result.getKeys()[i];
			try{
				ASValuePool value = (ASValuePool)result.getAttribute(key);
				paseResult(value,returns,keyName+"."+key);
				
			}catch(Exception e){
				String sValue = (String)result.getAttribute(key);
				returns.put(keyName+"."+key, sValue);
				isPool = false;
			}
		}
	}
	
	private ASValuePool parseJSON(JSONObject json) throws Exception{
		boolean isJSON = true;
		ASValuePool pool = new ASValuePool();
		Iterator it = json.keys();
		while(isJSON){
			while(it.hasNext()){
				String key = (String) it.next();
				//System.out.println(key);
				try{
					JSONObject value = json.getJSONObject(key);
					if(!value.keys().hasNext()){
						pool.setAttribute(key, value);
						isJSON = false;
					}else{
						pool.setAttribute(key, parseJSON(value));
					}
				}catch(Exception e){
					String sValue = json.getString(key);
					pool.setAttribute(key, sValue);
					isJSON = false;
				}
				
			}
			break;
		}
		
		return pool;
	}
	
	public HashMap<String,BusinessObject> getShowResult(List<BizObject> allResult) throws Exception{
		 
		HashMap<String,BusinessObject> resultMap = new HashMap<String,BusinessObject>();
		if(allResult!=null)
		for(BizObject bor: allResult){
			RuleResultPaser rrp = new RuleResultPaser( bor.getAttribute("Result").toString());
	    	ASValuePool data = rrp.paseReturn();
	    	HashMap<String,String> mapTemp = new HashMap<String,String>();
	    	rrp.paseResult(data,mapTemp,"");
	    	
	    	for(Iterator it = mapTemp.keySet().iterator();it.hasNext();){
	    		String keyTemp = (String)it.next();
	    		String valueTemp = mapTemp.get(keyTemp);
	    		BusinessObject bo=resultMap.get(keyTemp);
	    		if(bo==null){
	    			bo = BusinessObject.createBusinessObject();
	    			if(keyTemp.endsWith("_R")){
	    				String ItemName = keyTemp.substring(0,keyTemp.indexOf("_R"));
	    				resultMap.put(ItemName, bo);
	    				bo.setAttributeValue("ItemName",ItemName);
	    				bo.setAttributeValue("ItemReturnValue",valueTemp);
	    			}else{
	    				resultMap.put(keyTemp, bo);
	    				bo.setAttributeValue("ItemName",keyTemp);
	    				bo.setAttributeValue("ItemResult",valueTemp);
	    			}
	    		} else{
	    			if(keyTemp.endsWith("_R")){
	    				String ItemName = keyTemp.substring(0,keyTemp.indexOf("_R"));
	    				bo.setAttributeValue("ItemName",ItemName);
	    				bo.setAttributeValue("ItemReturnValue",valueTemp);
	    			}else{
	    				bo.setAttributeValue("ItemName",keyTemp);
	    				bo.setAttributeValue("ItemResult",valueTemp);
	    			}
	    		}
	    		 
	    	}
		}
		return resultMap;
	}
	
	public  List<BusinessObject> getSortResult(List<BizObject> allResult) throws Exception{
		HashMap<String,BusinessObject> resultMap = this.getShowResult(allResult);
		ArrayList resultList = new ArrayList();
		HashMap<String,ArrayList<BusinessObject>> resultMapTemp = new HashMap<String,ArrayList<BusinessObject>>();
		for(Iterator it = resultMap.keySet().iterator();it.hasNext();){
			String keyTemp = (String)it.next();
			BusinessObject bo = resultMap.get(keyTemp);
			String result = bo.getAttribute("ItemResult").toString();
			if(resultMapTemp.get(result)==null){
				ArrayList<BusinessObject>  arrayList = new ArrayList<BusinessObject>();
				arrayList.add(bo);
				resultMapTemp.put(result, arrayList);
			}else{
				resultMapTemp.get(result).add(bo);
			}
		}
		for(Iterator it = resultMapTemp.keySet().iterator();it.hasNext();){
			ArrayList<BusinessObject> arrayList = resultMapTemp.get(it.next());
			resultList.addAll(arrayList);
		}
		return resultList;
	}
	//定价结果调整展示顺序
	public List<String[]>  sortPrice(HashMap<String,String> map){
		List<String[]>  resultList = new ArrayList<String[]>() ;
		HashMap<String,LinkedList<String[]>> mapTemp = new HashMap<String,LinkedList<String[]>>();
		String resultItem = null;
		String resultValue =null;
		String groupname =null;
		for(Iterator it = map.keySet().iterator(); it.hasNext();){
	    	resultItem = (String)it.next();
	    	String key = resultItem;
	    	resultValue = (String)map.get(resultItem);
	    	if(resultItem.startsWith(".")){
	    		resultItem=resultItem.substring(1, resultItem.length());	    		
	    	}
	    	groupname=resultItem.substring(0,resultItem.indexOf("."));
	    	resultItem =resultItem.substring( resultItem.indexOf(".")+1,resultItem.length());
	    	resultItem = StringFunction.replace(resultItem, "果.", "");
	    	
	    	String[] result = new String[3];
			result[0]=groupname;
	    	result[1]=resultItem;
	    	result[2]=resultValue;
	    	resultValue=""+Arith.round(Double.parseDouble(resultValue),6);
	    	LinkedList<String[]> array = null;
	    	if(mapTemp.get(groupname)==null){
	    		array = new LinkedList<String[]>();
	    		mapTemp.put(groupname, array);
	    	}else{
	    		array = mapTemp.get(groupname);
	    	} 
    		if(resultItem.contains("浮动比例")){
    			array.addFirst(result);
    		}else{
    			array.add(result);
    		}
	    	/*String[] result=new String[3];
	    	result[0]=groupname;
	    	result[1]=resultItem;
	    	result[2]=resultValue;*/
		 }
		for(Iterator it = mapTemp.keySet().iterator(); it.hasNext();){
			resultList.addAll(mapTemp.get(it.next()));
		}
		
		return resultList;
		
	}
	public static void main(String args []){
		 
	}
	
}
