package com.amarsoft.app.awe.config.formatdoc.model.myscore;

import java.io.File;
import java.io.FileInputStream;

import javax.servlet.http.HttpServletRequest;

import com.amarsoft.biz.formatdoc.model.FormatDocHelp;
import com.amarsoft.biz.formatdoc.model.score.ScoreHandler;
import com.amarsoft.are.ARE;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.awe.ui.model.ButtonItem;
import com.amarsoft.awe.ui.widget.Button;

public class Als7ScoreHandler implements ScoreHandler{
	
	protected String score = "";//分数
	protected String scoreDesc="";//分数描述
	protected String avgscore = "";//平均分
	protected String conclusion = "";//报告结论
		
	protected java.io.InputStream ins = null;
	protected File file=null;
	protected BizObjectManager manager;
	protected BizObject objscore;

	public String createEditContent(HttpServletRequest request,String dataSerialNo)throws Exception {
		init(request,dataSerialNo);
		file = new File(request.getRealPath("/") + "/AppConfig/FormatDoc/score.html");
		return getContent();
	}

	public String createReadonlyContent(HttpServletRequest request,String dataSerialNo)throws Exception {
		init(request,dataSerialNo);
		file = new File(request.getRealPath("/") + "/AppConfig/FormatDoc/check.html");
		return getContent();
	}

	public String createSaveContent(HttpServletRequest request,String dataSerialNo)throws Exception {
		manager = JBOFactory.getFactory().getManager("jbo.app.FORMATDOC_DATA");
		objscore = manager.createQuery("serialno=:serialno").setParameter("serialno",dataSerialNo).getSingleResult();
		file = new File(request.getRealPath("/") + "/AppConfig/FormatDoc/score.html");
		score = request.getParameter("score");
		scoreDesc = request.getParameter("desc");
		
		conclusion = request.getParameter("conclusion");
		
		objscore.getAttribute("SCORE").setValue(score);
		objscore.getAttribute("SCOREDESC").setValue(scoreDesc);
		manager.saveObject(objscore);
		String relativeSerialNo = objscore.getAttribute("RelativeSerialNo").getString();
		BizObject bo = manager.createQuery("select sum(SCORE) as V.avgscore from O where O.RelativeSerialNo=:relativeSerialNo").setParameter("relativeSerialNo", relativeSerialNo).getSingleResult();
		avgscore = (100-bo.getAttribute("avgscore").getInt())+"";
		
		manager = JBOFactory.getFactory().getManager("jbo.app.FORMATDOC_RECORD");
		objscore = manager.createQuery("SerialNo=:SerialNo").setParameter("SerialNo",relativeSerialNo).getSingleResult();
		objscore.getAttribute("CONCLUSION").setValue(conclusion);
		manager.saveObject(objscore);
		return getContent();
	}

	protected void init(HttpServletRequest request,String dataSerialNo)throws Exception{
		manager = JBOFactory.getFactory().getManager("jbo.app.FORMATDOC_DATA");
		objscore = manager.createQuery("serialno=:serialno").setParameter("serialno",dataSerialNo).getSingleResult();
		String relativeSerialNo = objscore.getAttribute("RelativeSerialNo").getString();
		BizObject bo = manager.createQuery("select sum(SCORE) as V.avgscore from O where O.RelativeSerialNo=:relativeSerialNo").setParameter("relativeSerialNo", relativeSerialNo).getSingleResult();
		avgscore = (100-bo.getAttribute("avgscore").getInt())+"";
		score = objscore.getAttribute("SCORE").getString();
		
		if(score==null )score="";
		scoreDesc = objscore.getAttribute("SCOREDESC").getString();
		if(scoreDesc==null )scoreDesc="";
		manager = JBOFactory.getFactory().getManager("jbo.app.FORMATDOC_RECORD");
		objscore = manager.createQuery("SerialNo=:SerialNo").setParameter("SerialNo",relativeSerialNo).getSingleResult();
		conclusion = objscore.getAttribute("CONCLUSION").getString();
		if(conclusion==null)conclusion="";
	}
	
	protected String getContent()throws Exception{
		byte[] bytes = FormatDocHelp.getBytes(new FileInputStream(file));
		String sContent = new String(bytes,ARE.getProperty("CharSet","GBK"));
		sContent = sContent.replaceAll("#\\{score\\}",score);
		sContent = sContent.replaceAll("#\\{desc\\}",scoreDesc);
		if(avgscore==null)avgscore="";
		sContent = sContent.replaceAll("#\\{avgscore\\}",avgscore);
		if(conclusion==null)conclusion="";
		sContent = sContent.replaceAll("#\\{conclusion\\}",conclusion);
		//生成保存按钮
		ButtonItem btFIlter1 = new ButtonItem("保存","保存","saveScore()");
		sContent = sContent.replaceAll("#\\{button\\}",new Button(btFIlter1).getHtmlText());
		return sContent;
	}
}
