package com.amarsoft.app.oci.ws.decision.prepare;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

import javax.xml.namespace.QName;

import org.apache.axiom.om.OMElement;

import com.amarsoft.app.oci.OMGenerator;
import com.amarsoft.app.oci.ws.decision.prepare.util.Execute;
import com.amarsoft.app.oci.ws.decision.prepare.util.Init;
import com.amarsoft.are.ARE;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.dict.als.cache.AbstractCache;

public class CmdXMLConfig extends AbstractCache {

	private static String DEFAULT_MESSAGE_CONCFIG = "DecisionExecuteChain.xml";
	private static String DEFAULT_DECISION_CONCFIG = "IndApplyDecisionConnector.xml";
	private static CmdXMLConfig cmdXMLConfig = new CmdXMLConfig();

	private CmdXMLConfig() {
	}

	public static CmdXMLConfig newInstance() {
		return cmdXMLConfig;
	}

	private static List listInit;
	private static List listUnit;
	private static Init init;
	private static Execute execute;

	// 加载XML读取实例
	private void XMLreader(Transaction transaction) throws Exception {
		String aFileName = ARE.getProperty("CmdXMLConfig",DEFAULT_MESSAGE_CONCFIG);
		String aRootPath = ARE.getProperty("ConfigPath");
		if (aRootPath == null) throw new Exception("系统配置文件路径未初始化，请联系管理员重新加载！");
		String aFilePath = aRootPath + aFileName;
		File aFile = new File(aFilePath);
		FileInputStream afs = new FileInputStream(aFile);
		BufferedInputStream abs = new BufferedInputStream(afs);
		OMElement aElement = OMGenerator.parseIOtoOM(abs);
		listInit = getChildrenValue(aElement, "inits", "init");
		listUnit = getChildrenValue(aElement, "chain", "unit");
		
		String bFileName = ARE.getProperty("CmdXMLConfig",DEFAULT_DECISION_CONCFIG);
		String bRootPath = ARE.getProperty("ConfigPath");
		if (bRootPath == null) throw new Exception("系统配置文件路径未初始化，请联系管理员重新加载！");
		String bFilePath = bRootPath + bFileName;
		File bFile = new File(bFilePath);
		FileInputStream bfs = new FileInputStream(bFile);
		BufferedInputStream bbs = new BufferedInputStream(bfs);
		OMElement bElement = OMGenerator.parseIOtoOM(bbs);
		init = new  Init(bElement);
		execute = new Execute(bElement);
		
	}

	private static List getChildrenValue(OMElement element, String Firstname,String Secondname) {
		Iterator it = element.getChildrenWithName(new QName(Firstname));
		OMElement inits = (OMElement) it.next();
		it = inits.getChildrenWithName(new QName(Secondname));
		List list = new LinkedList();
		while (it.hasNext()) {
			Map<String, Object> map = new HashMap<String, Object>();
			OMElement om = (OMElement) it.next();
			String name = getNodeValue(om, "name");
			map.put("name", name);
			String describe = getNodeValue(om, "describe");
			map.put("describe", describe);
			String classname = getNodeValue(om, "classname");
			map.put("classname", classname);
			List outList = getPutNode("out", om);
			map.put("outMessage", outList);
			if (Firstname == "inits") {
				List iInlist = getPutNode("iIn", om);
				map.put("inMessage", iInlist);
				list.add(map);
			}
			if (Firstname == "chain") {
				List cInlist = getPutNode("cIn", om);
				map.put("inMessage", cInlist);
				list.add(map);
			}
		}
		return list;
	}

	private static List getPutNode(String putType, OMElement om) {
		List list = new LinkedList();
		if (putType == "out") getPutNode("outputpara", putType, om, list);
		else getPutNode("inputpara", putType, om, list);
		return list;
	}

	private static void getPutNode(String putpara, String putType,OMElement om, List list) {
		Iterator ip = om.getChildrenWithName(new QName(putpara));
		while (ip.hasNext()) {
			Map<String, Object> Map = new HashMap<String, Object>();
			OMElement ipom = (OMElement) ip.next();
			String paraname = getNodeValue(ipom, "paraname");
			Map.put("paraname", paraname);
			String paravalue = getNodeValue(ipom, "paravalue");
			Map.put("paravalue", paravalue);
			if (putType == "iIn") {
				String paraorder = getNodeValue(ipom, "paraorder");
				Map.put("paraorder", paraorder);
			}
			if (putpara == "outputpara") {
				String defaultValue = getNodeValue(ipom, "default");
				Map.put("default", defaultValue);
			}
			list.add(Map);
		}
	}

	private static String getNodeValue(OMElement om, String name) {
		OMElement temp = (OMElement) om.getChildrenWithName(new QName(name)).next();
		String ve = temp.getText();
		return ve;
	}

	// 获取Init列表
	public static List getListInit() {
		return listInit;
	}

	// 获取Unit列表
	public static List getListUnit() {
		return listUnit;
	}
	public static Init getInit(){
		return init;
	}
	public static Execute getExecute(){
		return execute;
	}
	@Override
	public void clear() throws Exception {
		listInit = new LinkedList();
		listUnit = new LinkedList();
	}

	@Override
	public boolean load(Transaction transaction) throws Exception {
		XMLreader(transaction);
		return true;
	}
}
