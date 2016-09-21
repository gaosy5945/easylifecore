package com.amarsoft.ars.core;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.io.Writer;
import java.sql.Connection;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import com.amarsoft.are.ARE;
import com.amarsoft.are.io.FileTool;
import com.amarsoft.ars.core.DataSheet;
import com.amarsoft.ars.file.FileUtils;

/**
 * DataSheet的子类，用于屏蔽在点击查看时，不会出现“重新统计”的功能 。
 * 
 * @author LCHDEV267
 * 
 */
public class DataSheetPLBS extends DataSheet {
	
	private String scriptHome = null;
	private static final long serialVersionUID = 1L;
	

	public DataSheetPLBS(String sDataSheetID, Connection conn) throws Exception {
		super(sDataSheetID, conn);
	}

	public void genSheetResultJS_BEA(String basepath, Writer wt)
			throws Exception {
		FileUtils fu = new FileUtils(basepath, this.Conditions);
		File file = new File(fu.getAbsoluteFileName()); 
		ARE.getLog().info("加载数据文件:\t" + fu.getAbsoluteFileName());
		try {
			if ((file.exists())) {
				fu.loadDataFromFile(wt, file);
			}
		} catch (Exception exception) {
			throw exception;
		} finally {
			fu = null;
		}
	}

	@Override
	public List initializeDataItem() throws Exception {
		String basePath = getScriptHome();
		ArrayList arraylist = new ArrayList();
		String fileDir = basePath +  this.SheetID;
		File dir =FileTool.findFile(fileDir);
		File[] fileList = dir.listFiles();
		for(File file:fileList){
			String filename = file.getName();
			if(!filename.endsWith("js"))continue; 
			BufferedReader br;
			StringBuilder itemScript = new StringBuilder("");
			try {
				br = new BufferedReader(new FileReader(file));
				String line = "";
				while ((line = br.readLine()) != null) {
					itemScript.append(line + "\n");
				}
				br.close();
			} catch (FileNotFoundException e) {
				e.printStackTrace();
			} catch (IOException e) {
				e.printStackTrace();
			}
			
			String ITEMSCRIPT = itemScript.toString();
			HashMap<String,Object> tempMap = new HashMap<String,Object>();
			tempMap.put("ITEMID", file.getName());
			tempMap.put("ITEMTITLE", "");
			tempMap.put("ITEMPROPERTY", "");
			tempMap.put("ITEMSCRIPT", ITEMSCRIPT);
			tempMap.put("PARENTID", "");
			tempMap.put("LINKPROPERTY", "");
			tempMap.put("LINKSCRIPT", "");
			tempMap.put("LINKORDER", "");
			arraylist.add(tempMap);
		}
		
		return arraylist;
	}
	
	public void setScriptHome(String scriptHome){
		this.scriptHome = scriptHome;
	}

	public String getScriptHome() {
		return scriptHome;
	}
	
}
