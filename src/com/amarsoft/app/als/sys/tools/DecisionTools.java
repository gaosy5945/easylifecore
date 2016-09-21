package com.amarsoft.app.als.sys.tools;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

import com.amarsoft.dict.als.cache.CodeCache;

public class DecisionTools {
	
	public static String getDecisionReason(String reasonCode) throws Exception{
		
		Pattern pc = Pattern.compile("[a-z,A-Z]\\d+");
		Matcher mc = pc.matcher(reasonCode);
		StringBuilder builderFocus = new StringBuilder();
		StringBuilder builderRefuse = new StringBuilder();
		String decisionCode = "";
		while(mc.find()){
			String code = mc.group(0);
			String codeName = CodeCache.getItemName("StrategyReason",code);
			if(code.startsWith("D")){
				builderRefuse.append(code);
				builderRefuse.append(":");
				builderRefuse.append(codeName);
				builderRefuse.append("\n");
			}
			else{
				builderFocus.append(code);
				builderFocus.append(":");
				builderFocus.append(codeName);
				builderFocus.append("\n");
			}			
		}
		if(!builderFocus.toString().equals("")){
			decisionCode = "�����Ĺ�ע����:\n"+builderFocus.toString();
		}
		if(!builderRefuse.toString().equals("")){
			decisionCode = decisionCode+"�����ľܾ�����:\n"+builderRefuse.toString();
		}
		return decisionCode;
	}
}
