package com.amarsoft.app.als.sys.tools;

import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.Map;

import com.amarsoft.are.ARE;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.util.json.JSONEncoder;
import com.amarsoft.dict.als.manage.CodeManager;
import com.amarsoft.dict.als.object.Item;

public class CodeGenerater {
	private String codeName;
	
	/**
	 * ��ȡ����JSON
	 * @return
	 */
	public String getCodeJson(JBOTransaction tx) throws Exception{
		return JSONEncoder.encode(getSource(codeName));
	}
	
	/**
	 * ��ѯCode�е�ֵ
	 * @param codeNo
	 * @return
	 * @throws Exception 
	 */
	private static Map<String , Object> getSource(String codeNo) throws Exception{
		Map<String , Object> map = new LinkedHashMap<String, Object>();
		Item[] items = CodeManager.getItems(codeNo);
		if(items == null) return map;
		for(Item item : items){
			map.put(item.getItemNo(), item.getItemName());
		}
		return map;
	}
	
	/**
	 * ��ȡ����Map<name , value>
	 * @param codeNo ������
	 * @return
	 */
	public static Map<String, Object> genCode(String codeNo) {
		try {
			return getSource(codeNo);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return new HashMap<String , Object>();
	}
	
	/**
	 * ͨ��ItemName��CodeNo��ȡItemNo
	 * @param itemName
	 * @param codeNo
	 * @return
	 */
	public static String getItemNoByName(String itemName, String codeNo){
		try{
			Item[] items = CodeManager.getItems(codeNo);
			for(Item it : items)
				if(it.getItemName().equals(itemName))
					return it.getItemNo();
		} catch (Exception e) {
			e.printStackTrace();
			ARE.getLog().error("����["+codeNo+" -"+itemName+"]��ȡItemNo����");
		}
		return  "";
	}
}
