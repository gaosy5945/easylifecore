package com.amarsoft.app.als.awe.ow.processor.impl.html.bodyhtml;

import java.text.DecimalFormat;
import java.util.ArrayList;

import com.amarsoft.app.base.util.ObjectWindowHelper;
import com.amarsoft.are.util.Arith;
import com.amarsoft.awe.dw.ASDataObject;
import com.amarsoft.awe.dw.ui.control.BasicInput;
import com.amarsoft.awe.dw.ui.control.ParentSelect;
import com.amarsoft.awe.dw.ui.control.Select;
import com.amarsoft.awe.dw.ui.page.body.FieldFomartFactory;
import com.amarsoft.awe.dw.ui.page.body.GenBodyDataImp1;
import com.amarsoft.awe.dw.ui.util.PublicFuns;

public class BodyHTMLGenerator1 extends GenBodyDataImp1 {
	private String dwname;

	public BodyHTMLGenerator1(ASDataObject asObj, ArrayList datas,
			String modehtml) {
		super(asObj, datas, modehtml);
		dwname=ObjectWindowHelper.getObjectWindowName(asObj);
	}

	protected BasicInput getInput(String inputname, String coleditstyle,
			String sourcetype, String source, String style, int coledistatus,
			String value, String split, String checkFormat, String collimit,
			String colAlign, String colInnerBtEvent) throws Exception {
		BasicInput input = null;
		if(!dwname.equals("0")) inputname=dwname+"_"+inputname;
		if ("1".equals(coleditstyle))
			coleditstyle = "Text";
		else if ("2".equals(coleditstyle))
			coleditstyle = "Select";
		else if ("3".equals(coleditstyle))
			coleditstyle = "Textarea";
		else if (coleditstyle.equals("")) {
			coleditstyle = "Text";
		}
		if (coleditstyle.equals("ParentSelect")) {
			if ((split == null) || (split.equals("")))
				split = "\\,";
			String[] aValue = value == null ? null : value.split(PublicFuns
					.filterRegularExpress(split));
			BasicInput input2 = new Select();
			input2.setName(inputname);
			input2.setEditStatus(coledistatus);
			input2.setRangeType(sourcetype);
			input2.appendExAttribute(" floatMenu='true'"
					+ input2.getExAttribute());

			input2.setRange(source.substring(0, source.indexOf("|")));

			String[] aSource = source.split("\\|");
			if (aSource.length < 2) {
				throw new Exception(inputname + "数据范围定义错误");
			}
			if (aValue != null) {
				if (aValue.length < aSource.length) {
					String[] aValueOld = aValue;
					aValue = new String[aSource.length];
					for (int i = 0; i < aValue.length; i++)
						if (i < aValueOld.length)
							aValue[i] = aValueOld[i];
				}
				try {
					input2.setValue(aValue[(aValue.length - 1)]);
				} catch (Exception e) {
					input2.setValue("");
				}
			}
			BasicInput lastinput = null;
			for (int i = 1; i < aSource.length; i++) {
				BasicInput inputi = null;
				if (i == 1)
					inputi = new ParentSelect(input2);
				else
					inputi = new ParentSelect(lastinput);
				inputi.setRangeType(sourcetype);
				inputi.setRange(aSource[0] + "|" + aSource[i]);
				if (aValue != null)
					try {
						inputi.setValue(aValue[(aValue.length - i - 1)]);
					} catch (Exception e) {
						inputi.setValue("");
					}
				inputi.setStyle(style);
				inputi.setEditStatus(coledistatus);
				lastinput = inputi;
			}
			input = lastinput;
		} else {
			if ((checkFormat.equals("1")) || (checkFormat.equals("3"))
					|| (checkFormat.equals("4"))) {
				input = (BasicInput) Class.forName(
						"com.amarsoft.awe.dw.ui.control." + coleditstyle)
						.newInstance();
				if ((this.onChangeScript != null)
						&& (this.onChangeScript.trim().length() > 0))
					input.appendExAttribute("onchange=\"" + this.onChangeScript
							+ "\"");
				if ((this.onKeyPressScript != null)
						&& (this.onKeyPressScript.trim().length() > 0))
					input.appendExAttribute("onkeypress=\""
							+ this.onKeyPressScript + "\"");
				if ((this.onClickScript != null)
						&& (this.onClickScript.trim().length() > 0))
					input.appendExAttribute("onclick=\"" + this.onClickScript
							+ "\"");
			} else if (checkFormat.equals("2")) {
				String sClsName = "KNumber";
				if (coleditstyle.equalsIgnoreCase("NumberRange"))
					sClsName = "NumberRange";
				input = (BasicInput) Class.forName(
						"com.amarsoft.awe.dw.ui.control." + sClsName)
						.newInstance();
				input.setSplitSize(2);
				if ((value != null) && (value.length() > 0)) {
					DecimalFormat df = new DecimalFormat("###,##0.00");
					value = df.format(Arith.round(
							Double.parseDouble(value.replaceAll(",", "")), 2));
				}

				input.appendExAttribute(" colcheckformat=\"2\"");
				input.appendExAttribute(FieldFomartFactory.getNumber("Number",
						2, this.onKeyPressScript));
				input.appendExAttribute(" onchange=\"if(this.value!='')this.value=FormatKNumber(this.value,2);"
						+ this.onChangeScript + "\"");
				input.appendExAttribute(" onbeforepaste=\"ReplaceNaN(this)\"");
				style = appendStyle(style, "ime-mode:Disabled;");
			} else if (checkFormat.equals("5")) {
				String sClsName = "KNumber";
				if ((value != null) && (value.length() > 0)) {
					DecimalFormat df = new DecimalFormat("###,###");
					value = df.format(Arith.round(
							Double.parseDouble(value.replaceAll(",", "")), 0));
				}

				if (coleditstyle.equalsIgnoreCase("NumberRange"))
					sClsName = "NumberRange";
				input = (BasicInput) Class.forName(
						"com.amarsoft.awe.dw.ui.control." + sClsName)
						.newInstance();

				input.appendExAttribute(" colcheckformat=\"5\"");
				input.appendExAttribute(FieldFomartFactory.getFomart("Integer",
						this.onKeyPressScript));
				input.appendExAttribute(" onchange=\"if(this.value!='')this.value=FormatKNumber(this.value,0);"
						+ this.onChangeScript + "\"");
				input.appendExAttribute(" onbeforepaste=\"ReplaceNaN(this)\"");
				style = appendStyle(style, "ime-mode:Disabled;");
			} else if (checkFormat.equals("6")) {
				String sClsName = "KNumber";
				if ((value != null) && (value.length() > 0)) {
					DecimalFormat df = new DecimalFormat("###,###");
					value = df
							.format(Arith.round(Double.parseDouble(value
									.replaceAll(",", "")) / 10000.0D, 0));
				}

				if (coleditstyle.equalsIgnoreCase("NumberRange"))
					sClsName = "NumberRange";
				input = (BasicInput) Class.forName(
						"com.amarsoft.awe.dw.ui.control." + sClsName)
						.newInstance();

				input.appendExAttribute(" colcheckformat=\"5\"");
				input.appendExAttribute(FieldFomartFactory.getFomart("Integer",
						this.onKeyPressScript));
				input.appendExAttribute(" onchange=\"if(this.value!='')this.value=FormatKNumber(this.value,0);"
						+ this.onChangeScript + "\"");
				input.appendExAttribute(" onbeforepaste=\"ReplaceNaN(this)\"");
				style = appendStyle(style, "ime-mode:Disabled;");
			} else if (checkFormat.equals("7")) {
				String sClsName = "KNumber";
				if (coleditstyle.equalsIgnoreCase("NumberRange"))
					sClsName = "NumberRange";
				input = (BasicInput) Class.forName(
						"com.amarsoft.awe.dw.ui.control." + sClsName)
						.newInstance();
				input.setSplitSize(2);
				if ((value != null) && (value.length() > 0)) {
					DecimalFormat df = new DecimalFormat("###,##0.00");
					value = df
							.format(Arith.round(Double.parseDouble(value
									.replaceAll(",", "")) / 10000.0D, 2));
				}

				input.appendExAttribute(" colcheckformat=\"2\"");
				input.appendExAttribute(FieldFomartFactory.getNumber("Number",
						2, this.onKeyPressScript));
				input.appendExAttribute(" onchange=\"if(this.value!='')this.value=FormatKNumber(this.value,2);"
						+ this.onChangeScript + "\"");
				input.appendExAttribute(" onbeforepaste=\"ReplaceNaN(this)\"");
				style = appendStyle(style, "ime-mode:Disabled;");
			} else if (checkFormat.matches("[0-9]+")) {
				String sClsName = "KNumber";
				if (coleditstyle.equalsIgnoreCase("NumberRange"))
					sClsName = "NumberRange";
				int iSize = Integer.parseInt(checkFormat) - 10;
				String sDots = "";
				for (int i = 0; i < iSize; i++)
					sDots = sDots + "0";
				if ((value != null) && (value.length() > 0)) {
					DecimalFormat df = new DecimalFormat("###,##0." + sDots);
					value = df.format(Arith.round(
							Double.parseDouble(value.replaceAll(",", "")),
							iSize));
				}

				input = (BasicInput) Class.forName(
						"com.amarsoft.awe.dw.ui.control." + sClsName)
						.newInstance();
				input.setSplitSize(iSize);
				input.appendExAttribute(" colcheckformat=\"" + checkFormat
						+ "\"");
				input.appendExAttribute(FieldFomartFactory.getNumber("Number",
						iSize, this.onKeyPressScript));
				input.appendExAttribute(" onchange=\"if(this.value!='')this.value=FormatKNumber(this.value,"
						+ iSize + ");" + this.onChangeScript + "\"");
				input.appendExAttribute(" onbeforepaste=\"ReplaceNaN(this)\"");
				style = appendStyle(style, "ime-mode:Disabled;");
			} else {
				input = (BasicInput) Class.forName(
						"com.amarsoft.awe.dw.ui.control." + coleditstyle)
						.newInstance();
				if ((this.onChangeScript != null)
						&& (this.onChangeScript.trim().length() > 0))
					input.appendExAttribute("onchange=\"" + this.onChangeScript
							+ "\"");
				if ((this.onKeyPressScript != null)
						&& (this.onKeyPressScript.trim().length() > 0))
					input.appendExAttribute("onkeypress=\""
							+ this.onKeyPressScript + "\"");
				if ((this.onClickScript != null)
						&& (this.onClickScript.trim().length() > 0))
					input.appendExAttribute("onclick=\"" + this.onClickScript
							+ "\"");
			}
			input.setName(inputname);
			input.setRange(source);
			if ((this.elseScript != null)
					&& (this.elseScript.trim().length() > 0))
				input.appendExAttribute(this.elseScript);
			input.setRangeType(sourcetype);
			input.setSplitchar(split);

			style = appendStyle(style, colAlign);
			input.setStyle(style);

			if ((!collimit.trim().equals("")) && (!collimit.equals("0"))) {
				input.appendExAttribute("maxlength=\"" + collimit + "\"");
			}
			input.setEditStatus(coledistatus);
			input.setValue(value);
		}
		input.setColInnerBtEvent(colInnerBtEvent);

		return input;
	}

	private String appendStyle(String oldStyle, String appendStyle) {
		if ((oldStyle == null) || (oldStyle.equals("")))
			oldStyle = appendStyle;
		else if (oldStyle.endsWith(";"))
			oldStyle = oldStyle + appendStyle;
		else
			oldStyle = oldStyle + ";" + appendStyle;
		return oldStyle;
	}

}
