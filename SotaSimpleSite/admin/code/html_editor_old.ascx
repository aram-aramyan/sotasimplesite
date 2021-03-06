<%@ Control Language="c#" targetSchema="http://schemas.microsoft.com/intellisense/ie5"%>
<%@ Import Namespace="Sota.Web.SimpleSite"%>
<script runat="server">
protected override void OnLoad(EventArgs e)
{
	Response.ContentEncoding = Encoding.UTF8;
	//Response.Cache.SetLastModified(new DateTime(2006,12,19));
}
</script>
<%string img = ResolveUrl("~/admin.ashx?img=editor");%>
<%string root = Request.QueryString["root"]!=null ? Request.QueryString["root"].TrimEnd('/')+"/" : ResolveUrl("~/");%>
<%string sCss = ResolveUrl(Config.Main.Css);%>
<link href="<%=ResolveUrl("~/admincss.ashx?css=")%>admin.htmleditor.css" type="text/css" rel="stylesheet">
<link href="<%=sCss%>/admin.htmleditor_inner.css" type="text/css" rel="stylesheet">
<script type="text/javascript">
	document.onkeydown = function() {
		var k = event.keyCode;
		var ctrl = event.ctrlKey;
		if (k == 83 && ctrl) {
			Ok_Click();
		}
	}
	function cmnInformation() {
		this.sUser_agent = navigator.userAgent.toLowerCase();
		this.bIE = true;
		this.bOpera = false;
		this.bMAC = false;
		this.bGecko = false;
		this.bMozilla = false;
		this.sLanguage = null;
		this.bHTTP = null;
		return this;
	}
	var cmn_oInformation = new cmnInformation();

	function cmnInit_Information() {
		cmn_oInformation.sLanguage = (document.body && document.body.getAttribute('lang') != '') ? document.body.getAttribute('lang') : 'ru';
		cmn_oInformation.bHTTP = (document.location.href.indexOf('http://') == 0) ? true : false;
	}

	cmnAdd_event(window, 'load', cmnInit_Information);


	function cmnAdd_event(eOn, sEvent_type, ptrFunction) {
		if (eOn.addEventListener) {
			eOn.addEventListener(sEvent_type, ptrFunction, false);
		} else if (eOn.attachEvent) {
			eOn.attachEvent('on' + sEvent_type, ptrFunction);
		}
	}

	cmnAdd_event(window, 'load', atkAllow_tab_key_in_text_inputs);

	function atkAllow_tab_key_in_text_inputs() {
		var aeText_input = document.getElementsByTagName('TEXTAREA');
		for (var i = 0; i < aeText_input.length; i++) {
			if (aeText_input[i].bTab_pressed != false) {
				atkAllow_tab_key_for(aeText_input[i]);
			}
		}
	}

	atk_aeText_input = new Array();

	function atkAllow_tab_key_for(eInput) {
		if (cmn_oInformation.bIE) {
			cmnAdd_event(eInput, 'keydown',
			function(e) {
				if (window.event.keyCode == 9) {
					var etcRange = document.selection.createRange();
					if (etcRange.text.length) {
						if (window.event.shiftKey) {
							etcRange.text = atkRemove_tabs(etcRange.text);
						} else {
							etcRange.text = atkInsert_tabs(etcRange.text);
						}
					} else {
						etcRange.text = '\t';
					}
					return false;
				}
			}
		);
		} else if (eInput && eInput.selectionStart) {
			var i = atk_aeText_input.length;
			atk_aeText_input[i] = eInput;
			cmnAdd_event(eInput, 'keydown',
			function(e) {
				if (e.keyCode == 9) {
					this.bTab_pressed = true;
					var iScroll_top = this.scrollTop;
					var iStart = this.selectionStart;
					var sA = this.value.substring(0, iStart);
					var sB = this.value.substring(iStart, this.selectionEnd);
					var bSelection = false;
					var sC = this.value.substring(this.selectionEnd, this.value.length);
					if (sB.length) {
						bSelection = true;
						if (e.shiftKey) {
							sB = atkRemove_tabs(sB);
						} else {
							sB = atkInsert_tabs(sB);
						}
					} else {
						sB = '\t';
					}
					this.value = sA + sB + sC;
					this.focus();
					if (bSelection) {
						this.selectionStart = iStart;
						this.selectionEnd = iStart + sB.length;
					} else {
						this.selectionStart = ++iStart;
						this.selectionEnd = iStart;
					}
					this.scrollTop = iScroll_top;
				}
			}
		);
			cmnAdd_event(eInput, 'blur',
			function(e) {
				if (this.bTab_pressed) {
					this.bTab_pressed = false;
					setTimeout('atk_aeText_input[' + i + '].focus()', 1);
				}
			}
		);
		}
		eInput.bTab_pressed = false;
	}

	function atkRemove_tabs(sText) {
		return sText.replace(/(^|\n)\t/g, '$1');
	}

	function atkInsert_tabs(sText) {
		return sText.replace(/(^|\n)([\t\S])/g, '$1\t$2');
	}

	var bAllow_tab_key_script_loaded = true;
</script>
<script type="text/javascript">
<!--
	window.onload = function() {
		cmnInit_Information();

		SotaHtmlEditor_InitSymbols();

		document.onclick = HideCustomPopup;
		document.designMode = 'On';

		var t = SotaHtmlEditor_GetTextArea('txtBody');
		atkAllow_tab_key_for(t);

		var d = SotaHtmlEditor_GetViewDiv('txtBody');
		d.contentEditable = true;

		if (window.dialogArguments) {
			field = window.dialogArguments;
		}
		if (field) {
			SotaHtmlEditor_SetContent('txtBody', field.value, true);
		}
	}
//-->
</script>
<script type="text/javascript">
<!--
var DocumentCacheById = new Object();
function getE(id, clear)
{
	if(clear)
	{
		clear = true;
	}
	if(DocumentCacheById[id] & clear!=true)
	{
		return DocumentCacheById[id];
	}
	else
	{
		var obj = document.getElementById(id);
		if(obj)
		{
			DocumentCacheById[id] = obj;
		}
		return obj;
	}
}
function SotaHtmlEditor_GetToolBarButtonByName(id, name)
{
	return getE(id+'_tbtn_'+name);
}
//Ссылка на дизайнер
function SotaHtmlEditor_GetViewDiv(id)
{
	return 	getE(id+"_view");
}
//Ссылка на HTML
function SotaHtmlEditor_GetTextArea(id)
{
	return 	getE(id);
}
//Изменить режим
function SotaHtmlEditor_ChangeView(id, view)
{
	SotaHtmlEditor_GetViewDiv(id).style.display		= view ? 'block' : 'none';
	SotaHtmlEditor_GetTextArea(id).style.display	= view ? 'none' : 'block'; 
	getE(id+'_btn_mode_html').className	= view ? '' : 'selected';
	getE(id+'_btn_mode_view').className	= view ? 'selected' : '';
	SotaHtmlEditor_HideCurrentPath(id);
}
//Переключиться в режим HTML
function SotaHtmlEditor_GoToHtml(id)
{
	SotaHtmlEditor_ChangeView(id, false);
}
//Переключиться в режим дизайнера
function SotaHtmlEditor_GoToView(id)
{
	SotaHtmlEditor_ChangeView(id, true);
}
//В режиме HTML
function SotaHtmlEditor_IsInHtmlMode(id)
{
	return 	SotaHtmlEditor_GetViewDiv(id).style.display=='none'; 
}
//В режиме дизайнера
function SotaHtmlEditor_IsInViewMode(id)
{
	return 	SotaHtmlEditor_GetTextArea(id).style.display=='none'; 
}
//Нажатие кнопки переключения в режим HTML
function SotaHtmlEditor_ButtonToHtmlClick(id)
{
	SotaHtmlEditor_UpdateContent(id);
	SotaHtmlEditor_GoToHtml(id);
}
//Нажатие кнопки переключения в режим дизайнера
function SotaHtmlEditor_ButtonToViewClick(id)
{
	SotaHtmlEditor_UpdateView(id);
	SotaHtmlEditor_GoToView(id);
}
//Ничего не делать
function SotaHtmlEditor_Nothing()
{
}
//Устанавливает весь HTML
function SotaHtmlEditor_SetContent(id, text, updateView)
{
	SotaHtmlEditor_GetTextArea(id).value = text;
	if(updateView)
		SotaHtmlEditor_UpdateView(id);
}
//Обновляет HTML
function SotaHtmlEditor_UpdateContent(id)
{
	SotaHtmlEditor_GetTextArea(id).innerText = SotaHtmlEditor_RemoveRelativeLinks(SotaHtmlEditor_GetXHTML(SotaHtmlEditor_GetViewDiv(id)));
}
//Обновляет дизайнер
function SotaHtmlEditor_UpdateView(id)
{
	SotaHtmlEditor_GetViewDiv(id).innerHTML =  SotaHtmlEditor_AddRelativeLinks(SotaHtmlEditor_GetTextArea(id).innerText);
}
//Форматирование текста
function SotaHtmlEditor_FormatText(id, style, value, smart)
{
	if(SotaHtmlEditor_IsInHtmlMode(id))
		return;
	var d = SotaHtmlEditor_GetViewDiv(id);
	d.setActive();
	if(document.selection.type.toLowerCase()=='control')
		return;	
	var oRange = document.selection.createRange();
	var sHtml = oRange.htmlText;
	if(sHtml.length==0)
			return;
	var oEl			= oRange.parentElement();
	var resStyle	= ';'+style+': '+value;
	//определяем стиль
	if(smart)
	{
		switch(style)
		{
			case 'font-weight':
				if(oEl.style.fontWeight=='bold')
					resStyle = ';font-weight: normal';
				else
					resStyle = ';font-weight: bold';		
				break;
			case 'font-style':
				if(oEl.style.fontStyle=='italic')
					resStyle = ';font-style: normal';
				else
					resStyle = ';font-style: italic';		
				break;
			case 'text-decoration':
				var val		= value.toLowerCase();
				var scur	= oEl.style.textDecoration.toLowerCase();
				if(scur=='none')
					scur = value;
				else
				{
					if(scur.indexOf(val)!=-1)
					{
						scur = scur.replace(val,'');
						if(scur.length==0)
							scur = 'none';
					}
					else
						scur += ' '+val;
				}
				resStyle = ';text-decoration: '+scur;		
				break;
		}
	}
	//если полностью выделен элемент 
	//то новый не создаем - дописываем в существующий
	if((sHtml==oEl.outerHTML | sHtml==oEl.innerHTML) & oEl!=d)
	{
		oEl.style.cssText += resStyle;
	}
	else
	{
		oRange.pasteHTML('<span style=\"'+resStyle+'\">'+sHtml+'</span>');
	}
}
//Оборачивает выделенный HTML указанным HTML
function SotaHtmlEditor_InsertHtml(id, begin, end, check)
{
	if(SotaHtmlEditor_IsInHtmlMode(id))
	{
		SotaHtmlEditor_InsertText(id, begin, end, check);
	}
	else
	{	
		SotaHtmlEditor_GetViewDiv(id).setActive();
		if(document.selection.type.toLowerCase()=='control')
			return;
		var oRange = document.selection.createRange();
		if(check)
			if(oRange.htmlText.length==0)
				return;
		if(end)
			oRange.pasteHTML(begin+oRange.htmlText+end);
		else
			oRange.pasteHTML(begin);
	}
}
//Оборачивает выделенный текст указанным текстом
function SotaHtmlEditor_InsertText(id, begin, end, check)
{
	if(SotaHtmlEditor_IsInHtmlMode(id))
		SotaHtmlEditor_GetTextArea(id).setActive();
	else
		SotaHtmlEditor_GetViewDiv(id).setActive();
	if(document.selection.type.toLowerCase()=='control')
		return;
	var oRange = document.selection.createRange();
	if(check)
		if(oRange.text.length==0)
			return;
	if(end)
		oRange.text = begin+oRange.text+end;
	else
		oRange.text = begin;
}
//Сливает вложенные span 
function SotaHtmlEditor_MergeSpan(id)
{
	if(SotaHtmlEditor_IsInHtmlMode(id))
		return;
	SotaHtmlEditor_GetViewDiv(id).setActive();
	if(document.selection.type.toLowerCase()=='control')
		return;
	var oEl = document.selection.createRange().parentElement();
	var cst = oEl.style.cssText;
	while(oEl.parentElement.tagName.toLowerCase()=='span')
	{
		cst += ';'+oEl.style.cssText;
		oEl = oEl.parentElement;
	}
	oEl.style.cssText += ';'+cst;
	oEl.innerHTML = oEl.innerText;
}
//Очищает весь HTML
function SotaHtmlEditor_ClearAllHtml(id)
{
	if(SotaHtmlEditor_IsInHtmlMode(id))
		return;
	var d = SotaHtmlEditor_GetViewDiv(id);
	d.setActive();
	d.innerHTML = d.innerText;
}
//Очищает HTML у текущего элемента
function SotaHtmlEditor_ClearHtml(id)
{
	if(SotaHtmlEditor_IsInHtmlMode(id))
		return;
	SotaHtmlEditor_GetViewDiv(id).setActive();
	if(document.selection.type.toLowerCase()!='control')
	{
		var oEl = document.selection.createRange().parentElement();
		oEl.innerHTML = oEl.innerText;
	}	
}
//Выполнить команду
function SotaHtmlEditor_ExecCommand(id, sCommand, check, vValue)
{
	if(SotaHtmlEditor_IsInHtmlMode(id))
		return;
	SotaHtmlEditor_GetViewDiv(id).setActive();
	var oRange = document.selection.createRange();
	if(check)
		if(document.selection.type.toLowerCase()!='control')
			if(oRange.htmlText.length==0)
				return;
	oRange.execCommand(sCommand, false, vValue);
}
//Определить вложенность
function SotaHtmlEditor_GetCurrentPath(id)
{
	if(SotaHtmlEditor_IsInHtmlMode(id))
		return null;
	var arPath = new Array();
	var d = SotaHtmlEditor_GetViewDiv(id);
	d.setActive();
	var oEl;
	var oRange = document.selection.createRange();
	if(document.selection.type.toLowerCase()=='control')
		oEl = oRange(0);
	else
	{
		oEl = oRange.parentElement();
	}
	var i = 0;
	while(oEl)
	{
		if(oEl==d)
		{
			break;
		}
		arPath[arPath.length] = oEl.tagName.toLowerCase();
		oEl = oEl.parentElement;
	}
	return arPath;
}
//Скрыть вложенность
function SotaHtmlEditor_HideCurrentPath(id)
{
	getE(id+'_path').innerHTML = '';
}
//Показать вложенность
function SotaHtmlEditor_ShowCurrentPath(id)
{
	var arPath = SotaHtmlEditor_GetCurrentPath(id);
	if(arPath)
	{
		var d = getE(id+'_path');
		d.innerHTML = '&nbsp;';
		var a = document.createElement('A');
		a.href = 'javascript: SotaHtmlEditor_SelectAll(\''+id+'\');';
		a.innerText = '<body>';
		d.appendChild(a);
		for(var i=arPath.length-1;i>-1;i--)
		{
			d.innerHTML += '&nbsp;';
			var a = document.createElement('A');
			a.href = 'javascript: SotaHtmlEditor_SelectNodeContent(\''+id+'\','+i+');';
			a.innerText = '<' + arPath[i] + '>';
			d.appendChild(a);
		}
	}
}
//Выделить контент ветки
function SotaHtmlEditor_SelectNodeContent(id, n)
{
	if(SotaHtmlEditor_IsInHtmlMode(id))
		return;
	var d = SotaHtmlEditor_GetViewDiv(id);
	d.setActive();
	var oEl;
	var oRange = document.selection.createRange();
	if(document.selection.type.toLowerCase()=='control')
	{
		oEl = oRange(0);
	}
	else
	{
		oEl = oRange.parentElement();
		for(var i=0;i<n;i++)
		{
			oEl = oEl.parentElement;
		}
		oRange.moveToElementText(oEl);
		oRange.select();
	}
	SotaHtmlEditor_ShowCurrentPath(id);
}
//выделить весь контент
function SotaHtmlEditor_SelectAll(id)
{
	if(SotaHtmlEditor_IsInHtmlMode(id))
		return;
	var d = SotaHtmlEditor_GetViewDiv(id);
	d.setActive();
	var r = document.body.createTextRange();
	r.moveToElementText(d);
	r.select();
}
//убрать "старый" HTML
function SotaHtmlEditor_ClearOldHtml(id)
{
	var arBad = 'FONT,CENTER'.split(',');
	var d = SotaHtmlEditor_GetViewDiv(id);
	var s = d.innerHTML;
	for(var i=0;i<arBad.length;i++)
	{
		var pattern = new RegExp("<"+arBad[i]+"[^>]*>","gi");
		s = s.replace(pattern,"");
		pattern = new RegExp("</"+arBad[i]+">","gi");
		s = s.replace(pattern,"");
	}
	d.innerHTML = s;
}
function SotaHtmlEditor_ClearStyles(id)
{
	var d = SotaHtmlEditor_GetViewDiv(id);
	for(var i=0;i<d.children.length;i++)
		SotaHtmlEditor_clearStyles(d.children[i]);
}
function SotaHtmlEditor_clearStyles(el)
{
	if(el.style)
		el.style.cssText = "";
	if(el.className)
		if(el.className.length)
			el.removeAttribute('className');
	for(var i=0;i<el.children.length;i++)
		SotaHtmlEditor_clearStyles(el.children[i]);
}
function SotaHtmlEditor_Optimize(id)
{
	//SotaHtmlEditor_ClearOldHtml(id);
	SotaHtmlEditor_ClearStyles(id);
}

//добавляет к путям relative:
function SotaHtmlEditor_AddRelativeLinks(s)
{
	return s.replace(/href="/gi,'href="relative:');
}
//убирает relative:
function SotaHtmlEditor_RemoveRelativeLinks(s)
{
	return s.replace(/href="relative:/gi,'href="').replace(/src="http:\/\/<%=Path.Domain.Replace("/","\\/")%>\//gi,'src="<%=Path.VRoot.Replace("/","\\/")%>');
}
function SotaHtmlEditor_ChangeCase(id,upper)
{
	if(SotaHtmlEditor_IsInHtmlMode(id))
		return;
	SotaHtmlEditor_GetViewDiv(id).setActive();
	if(document.selection.type.toLowerCase()=='control')
		return;
	var oRange = document.selection.createRange();
	if(upper)
		oRange.text = oRange.text.toUpperCase();
	else
		oRange.text = oRange.text.toLowerCase();
}
function SotaHtmlEditor_GetXHTML(el)
{
	//return el.innerHTML;
	var children = el.childNodes;
	var s = '';
	for(var i=0;i<children.length;i++)
	{
		s+=SotaHtmlEditor_GetNodeXHTML(children[i],'');
	}
	var m = s.match(/^\s*(\S+(\s+\S+)*)\s*$/);
    s = (m == null) ? '' : m[1];
	return s.replace(/(\s*\n[\t]*){2,}/gi,'$1');
}
function SotaHtmlEditor_IsBlockElement(tag)
{
	var s = ',br,em,strong,a,b,u,i,nobr,span,sup,sub,strike,img,label,input,select,';
	return (s.indexOf(','+tag+',')==-1);
}
function SotaHtmlEditor_MustHaveChildElement(tag)
{
	var s = ',p,';
	return (s.indexOf(','+tag+',')==-1);
}
var SotaHtmlEditor_NewLine = '\n';
function SotaHtmlEditor_GetNodeXHTML(htmlNode, indent)
{
	if(htmlNode.nodeType==3)//Текст
	{
		var s = htmlNode.nodeValue;
		if(s)
		{
			var asPieces = s.match( SotaHtmlEditor_XHTMLEntitiesRegex ) ;
			var newS = '';

			if ( asPieces )
			{
				for ( var i = 0 ; i < asPieces.length ; i++ )
				{
					if ( asPieces[i].length == 1 )
					{
						var sEntity = SotaHtmlEditor_XHTMLEntities[ asPieces[i] ] ;
						if ( sEntity != null )
						{
							newS+='&'+sEntity+';';
							continue ;
						}
					}
					newS+= asPieces[i];
				}
			}
			return newS.replace(/(.{50,}?)\s+/gi,'$1\n'+indent);
		}
		return '';
	}
	else if(htmlNode.nodeType==8)//Комментарий
	{
		return htmlNode.outerHTML;
	}
	else if(htmlNode.nodeType==1)//Элемент
	{
		var tag = htmlNode.tagName.toLowerCase();
		//если это забытый закрывающий тэг
		if(tag.indexOf('/')==0)
			return '';
		var s = '<'+tag;
		var aAttributes = htmlNode.attributes;
		if(tag=='img')
		{
			var attr = aAttributes.getNamedItem('alt');
			if(attr.nodeValue=='')
			{	
				attr.nodeValue = '';
			}
			attr = aAttributes.getNamedItem('src');
			if(attr.nodeValue=='')
			{	
				attr.nodeValue = 'none.gif';
			}
		}
		for(var i = 0;i < aAttributes.length;i++)
		{
			var oAttribute = aAttributes[i] ;
			if (oAttribute.specified)
			{
				var sAttName = oAttribute.nodeName.toLowerCase();
				var sAttValue;

				if (sAttName == 'style')
					sAttValue = htmlNode.style.cssText.toLowerCase();
				else if ( sAttName == 'class' || sAttName.indexOf('on') == 0 )
					sAttValue = oAttribute.nodeValue ;
				else if (oAttribute.nodeValue === true)
					sAttValue = sAttName ;
				else if (!(sAttValue = htmlNode.getAttribute(sAttName, 2)))
					sAttValue = oAttribute.nodeValue ;
				s+= ' '+sAttName+'="'+sAttValue+'"';
			}
		}
		if(!htmlNode.canHaveChildren)
		{
			if(htmlNode.innerHTML)
			{
				s+='>'+htmlNode.innerHTML+'</'+tag+'>';
			}
			else
			{
				s+=' />';
			}
		}
		else
		{
			s+='>';
			var children = htmlNode.childNodes;
			if(children.length==0)
			{
				if(SotaHtmlEditor_MustHaveChildElement(tag))
				{
					s+='&nbsp;';
				}
				else
				{
					return '';
				}
			}
			for(var i=0;i<children.length;i++)
			{
				s+=SotaHtmlEditor_GetNodeXHTML(children[i],indent+'\t');
			}
			s+='</'+tag+'>';
		}
		if(SotaHtmlEditor_IsBlockElement(tag))
		{
			s=SotaHtmlEditor_NewLine+indent+s+SotaHtmlEditor_NewLine+indent.replace('\t','');
		}
		return s;
	}
	else
	{
		return '<!--[##{'+htmlNode.outerHTML+'}##]-->';
	}
}
////////////////////////////////////////////////////////////
var SotaHtmlEditor_XHTMLEntities = null;
var SotaHtmlEditor_XHTMLEntitiesRegex = null;
function SotaHtmlEditor_InitSymbols()
{
	SotaHtmlEditor_XHTMLEntities = {
			// Latin-1 Entities
			' ':'nbsp',
			'¡':'iexcl',
			'¢':'cent',
			'£':'pound',
			'¤':'curren',
			'¥':'yen',
			'¦':'brvbar',
			'§':'sect',
			'¨':'uml',
			'©':'copy',
			'ª':'ordf',
			'«':'laquo',
			'¬':'not',
			'­':'shy',
			'®':'reg',
			'¯':'macr',
			'°':'deg',
			'±':'plusmn',
			'²':'sup2',
			'³':'sup3',
			'´':'acute',
			'µ':'micro',
			'¶':'para',
			'·':'middot',
			'¸':'cedil',
			'¹':'sup1',
			'º':'ordm',
			'»':'raquo',
			'¼':'frac14',
			'½':'frac12',
			'¾':'frac34',
			'¿':'iquest',
			'×':'times',
			'÷':'divide',
			'ø':'oslash',

			// Symbols and Greek Letters 

			'ƒ':'fnof',
			'•':'bull',
			'…':'hellip',
			'′':'prime',
			'″':'Prime',
			'‾':'oline',
			'⁄':'frasl',
			'℘':'weierp',
			'ℑ':'image',
			'ℜ':'real',
			'™':'trade',
			'ℵ':'alefsym',
			'←':'larr',
			'↑':'uarr',
			'→':'rarr',
			'↓':'darr',
			'↔':'harr',
			'↵':'crarr',
			'⇐':'lArr',
			'⇑':'uArr',
			'⇒':'rArr',
			'⇓':'dArr',
			'⇔':'hArr',
			'∀':'forall',
			'∂':'part',
			'∃':'exist',
			'∅':'empty',
			'∇':'nabla',
			'∈':'isin',
			'∉':'notin',
			'∋':'ni',
			'∏':'prod',
			'∑':'sum',
			'−':'minus',
			'∗':'lowast',
			'√':'radic',
			'∝':'prop',
			'∞':'infin',
			'∠':'ang',
			'∧':'and',
			'∨':'or',
			'∩':'cap',
			'∪':'cup',
			'∫':'int',
			'∴':'there4',
			'∼':'sim',
			'≅':'cong',
			'≈':'asymp',
			'≠':'ne',
			'≡':'equiv',
			'≤':'le',
			'≥':'ge',
			'⊂':'sub',
			'⊃':'sup',
			'⊄':'nsub',
			'⊆':'sube',
			'⊇':'supe',
			'⊕':'oplus',
			'⊗':'otimes',
			'⊥':'perp',
			'⋅':'sdot',
			'◊':'loz',
			'♠':'spades',
			'♣':'clubs',
			'♥':'hearts',
			'♦':'diams',

			// Other Special Characters 

			'"':'quot',
			'&':'amp',		// This entity is automatically handled by the XHTML parser.
			'<':'lt',		// This entity is automatically handled by the XHTML parser.
			'>':'gt',		// This entity is automatically handled by the XHTML parser.
			'ˆ':'circ',
			'˜':'tilde',
			' ':'ensp',
			' ':'emsp',
			' ':'thinsp',
			'‌':'zwnj',
			'‍':'zwj',
			'‎':'lrm',
			'‏':'rlm',
			'–':'ndash',
			'—':'mdash',
			'‘':'lsquo',
			'’':'rsquo',
			'‚':'sbquo',
			'“':'ldquo',
			'”':'rdquo',
			'„':'bdquo',
			'†':'dagger',
			'‡':'Dagger',
			'‰':'permil',
			'‹':'lsaquo',
			'›':'rsaquo',
			'€':'euro'
		} ;
	var Chars = '';
	for ( var e in SotaHtmlEditor_XHTMLEntities )
	{
		Chars += e ;
	}
	SotaHtmlEditor_XHTMLEntitiesRegex = new RegExp('[' + Chars + ']|[^' + Chars + ']+','g') ;
}

////////////////////////////////////////////////////////////
var CustomPopupWindow = null;
function CreateCustomPopup(w,h)
{
	var b = document.body;
	var l =	b.clientWidth/2+b.clientLeft-w/2;
	var t =	b.clientHeight/2+b.clientTop-h/2;
	HideCustomPopup();
	CustomPopupWindow = window.open('<%=ResolveUrl("~/admin/blank.aspx")%>',null,'height='+h+',width='+w+',left='+l+',top='+t);
	CustomPopupWindow.DialogBodyCss = 'margin:0;background:buttonface;';
}
function HideCustomPopup()
{
	if(CustomPopupWindow)
	{
		CustomPopupWindow.close();
		CustomPopupWindow = null;
	}
}
function getDE(id)
{
	if(CustomPopupWindow)
		return CustomPopupWindow.document.getElementById(id);
	return null;
}
function InsertLink()
{
	try
	{
		CreateCustomPopup(300,185);
		CustomPopupWindow.DialogTitle = 'Вставка ссылки';
		CustomPopupWindow.DialogBodyHtml = getE('SotaHtmlEditor_insert_link_dialog').innerHTML;
	}
	catch(ex)
	{
		HideCustomPopup();
	}
}
function InsertLink_Ok()
{
	var href	= getDE('txtLink').value;
	var name	= getDE('txtName').value;
	var target	= getDE('cmbTarget').value;
	var type	= getDE('cmbType').value;
	var title	= getDE('txtTitle').value;
	var islink	= getDE('rbLink').checked;
	var check	= 0;
	HideCustomPopup();
	var a = '<a';
	if(islink)
	{
		if(href)
			a+=' href=\"relative:'+type+href+'\"';
		else
			return;
		if(target)
		{
			if(target=='xhtml_blank')
				a+=' onclick=\"window.open(this.href);return false;\"';
			else
				a+=' target=\"'+target+'\"';
		}
		if(title)
			a+=' title=\"'+title+'\"';
		check = 1;
	}
	else
	{
		if(name)
			a+=' name=\"'+name+'\"';
		else
			return;
	}
	a+='>';
	SotaHtmlEditor_InsertHtml('txtBody',a,'</a>', check);
}
function InsertImage()
{
	try
	{
		CreateCustomPopup(500,245);
		CustomPopupWindow.DialogTitle = 'Вставка изображения';
		CustomPopupWindow.DialogBodyHtml = getE('SotaHtmlEditor_insert_image_dialog').innerHTML;
	}
	catch(ex)
	{
		HideCustomPopup();
	}
}
function InsertImage_Ok()
{
	var src		= getDE('txtImage').value;
	var alt		= getDE('txtImageAlt').value;
	var align	= getDE('cmbImageAlign').value;
	var border	= getDE('txtImageBorder').value;
	var hspace	= getDE('txtImageHSpace').value;
	var vspace	= getDE('txtImageVSpace').value;
	var height	= getDE('txtImageHeight').value;
	var width	= getDE('txtImageWidth').value;
	HideCustomPopup();
	var i = '<img';
	if(src)
		i+=' src=\"<%=root%>'+src+'\"';
	else
		return;
	i+=' alt=\"'+alt+'\"';
	if(align.length)
		i+=' align=\"'+align+'\"';
	if(border.length)
		i+=' border=\"'+border+'\"';
	if(hspace.length)
		i+=' hspace=\"'+hspace+'\"';
	if(vspace.length)
		i+=' vspace=\"'+vspace+'\"';
	if(width.length)
		i+=' width=\"'+width+'\"';
	if(height.length)
		i+=' height=\"'+height+'\"';
	i+='>';
	SotaHtmlEditor_InsertHtml('txtBody',i);
}
function OpenImageExplorer()
{
	CustomPopupWindow.blur();
	var url = '<%=ResolveUrl(Config.Main.FileManagerPage)%>?field=txtImage&root=<%=root%>&filter=gif;jpg;jpeg;bmp;png';
	var res = showModalDialog(url, null, 'dialogWidth:650px;dialogHeight:550px;help:no;status:no;scroll:no;resizable:yes;');
	if(res)
	{
		getDE('txtImage').value = res;
	}
	CustomPopupWindow.focus();
}
function ImageChanged()
{
	ImagePreviewUpdate();
}
function ImagePreviewUpdate()
{
	var src		= getDE('txtImage').value;
	if(src.length==0)
		return;
	
	src			= '<%=root%>'+src;
	var align	= getDE('cmbImageAlign').value;
	var border	= getDE('txtImageBorder').value;
	var hspace	= getDE('txtImageHSpace').value;
	var vspace	= getDE('txtImageVSpace').value;
	var height	= getDE('txtImageHeight').value;
	var width	= getDE('txtImageWidth').value;

	var io	= new Image();
	io.src	= src;
	var i	= getDE('imgPreview');
	i.src	= src;
	if(align.length)
		i.align	= align;
	else
		i.align = io.align;
	if(border.length)
		i.border = border;
	else
		i.border = io.border;
	if(hspace.length)
		i.hspace = hspace;
	else
		i.hspace = io.hspace;
	if(vspace.length)
		i.vspace = vspace;
	else
		i.vspace = io.vspace;
	if(width.length)
		i.width = width;
	else
		i.width = io.width;
	if(height.length)
		i.height = height;
	else
		i.height = io.height;
}
function InsertTable()
{
	try
	{
		CreateCustomPopup(480,180);
		CustomPopupWindow.DialogTitle = 'Вставка таблицы';
		CustomPopupWindow.DialogBodyHtml = getE('SotaHtmlEditor_insert_table_dialog').innerHTML;
	}
	catch(ex)
	{
		HideCustomPopup();
	}
}
function InsertTable_Ok()
{
	var rows	= getDE('txtRows').value;
	var cols	= getDE('txtColumns').value;
	var align	= getDE('cmbAlign').value;
	var cellp	= getDE('txtCellP').value;
	var cells	= getDE('txtCellS').value;
	var w		= getDE('txtWidth').value;
	var h		= getDE('txtHeight').value;
	var cl		= getDE('txtClass').value;
	var b		= getDE('txtBorder').value;
	var s		= getDE('txtStyle').value;
	HideCustomPopup();
	try
	{
		rows	= parseInt(rows);
		cols	= parseInt(cols);
		if(rows<1 | cols<1)
			return;
	}
	catch(e)
	{
		return;
	}

	var t = "<table";
	if(align)
		t += " align=\""+align+"\"";
	if(cellp)
		t += " cellpadding=\""+cellp+"\"";
	if(cells)
		t += " cellspacing=\""+cells+"\"";
	if(w)
		t += " width=\""+w+"\"";
	if(h)
		t += " height=\""+h+"\"";
	if(cl)
		t += " class=\""+cl+"\"";
	if(b)
		t += " border=\""+b+"\"";
	if(s)
		t += " style=\""+s+"\"";
	t += ">";
	for(var i = 0;i<rows;i++)
	{
		t += "<tr>";
		for(var j=0;j<cols;j++)
		{
			t += "<td></td>";
		}	
		t += "</tr>";
	}
	t += "</table>";
	SotaHtmlEditor_InsertHtml('txtBody',t);
}
///////////////////////////////////////////////////////////////////////
var field;
function Ok_Click()
{
	if(field)
	{
		if(SotaHtmlEditor_IsInViewMode('txtBody')) SotaHtmlEditor_UpdateContent('txtBody');
		field.value = getE('txtBody').value;
	}
	window.close();
}
function Cancel_Click()
{
	window.close();
}
//////////////////////////////////////////////////////////////
//-->
</script>
<!--Диалоговое окно "Вставка ссылки"-->
<div id="SotaHtmlEditor_insert_link_dialog" style="display:none">
	<table width="100%" cellpadding="1" class="link_dialog_tb">
		<tr>
			<td>
				<fieldset>
					<table width="100%" cellpadding="2" border="0">
						<tr>
							<td>
								<input checked type="radio" name="rb" id="rbLink">
							</td>
							<td style="font-size:11px;font-family:Verdana">
								<label for="rbLink">Ссылка:</label>
							</td>
							<td width="100%">
								<input id="txtLink" type="text" style="width:100%;font-size:11px;font-family:Verdana">
							</td>
						</tr>
						<tr>
							<td>&nbsp;</td>
							<td style="font-size:11px;font-family:Verdana">
								Подсказка:
							</td>
							<td width="100%">
								<input id="txtTitle" type="text" style="width:100%;font-size:11px;font-family:Verdana">
							</td>
						</tr>
						<tr>
							<td>&nbsp;</td>
							<td style="font-size:11px;font-family:Verdana">Открыть:</td>
							<td>
								<select id="cmbTarget" style="width:100%;font-size:11px;font-family:Verdana">
									<option value=""></option>
									<option value="xhtml_blank">В новом окне(XHTML)</option>
									<option value="_blank">В новом окне</option>
									<option value="_self">В том же окне</option>
									<option value="_top">Поверх фреймов</option>
									<option value="_parent">В родительском окне</option>
								</select>
							</td>
						</tr>
						<tr>
							<td>&nbsp;</td>
							<td style="font-size:11px;font-family:Verdana">Тип:</td>
							<td>
								<select id="cmbType" style="width:100%;font-size:11px;font-family:Verdana">
									<option value=""></option>
									<option value="<%=ResolveUrl(Config.Main.RedirectPage)%>?url=">Редирект</option>
									<option value="<%=ResolveUrl(Config.Main.DownloadPage)%>?url=">Скачивание</option>
								</select>
							</td>
						</tr>
						<tr>
							<td>
								<input type="radio" name="rb" id="rbName">
							</td>
							<td style="font-size:11px;font-family:Verdana">
								<label for="rbName">Якорь:</label>
							</td>
							<td>
								<input id="txtName" type="text" style="width:100%;font-size:11px;font-family:Verdana">
							</td>
						</tr>
					</table>
				</fieldset>
			</td>
		</tr>
		<tr>
			<td>
				<fieldset>
					<table width="100%" cellpadding="2" border="0">
						<tr>
							<td align="right">
								<input type="button" value="ОК" onclick="opener.InsertLink_Ok();" style="width:70px;font-size:11px;font-family:Verdana">
								<input type="button" value="Отмена" onclick="window.close();" style="width:70px;font-size:11px;font-family:Verdana">
							</td>
						</tr>
					</table>
				</fieldset>
			</td>
		</tr>
	</table>
</div>
<!--/Диалоговое окно "Вставка ссылки"-->
<!--Диалоговое окно "Вставка изображения"-->
<div id="SotaHtmlEditor_insert_image_dialog" style="display:none">
	<table width="100%" style="font-size:11px;font-family:Verdana" cellpadding="1">
		<tr>
			<td>
				<fieldset>
					<table cellpadding="1">
						<tr>
							<td style="font-size:11px;font-family:Verdana">Изображение:</td>
							<td width="100%">
								<input id="txtImage" style="font-size:11px;font-family:Verdana;width:100%" type="text"
									onpropertychange="opener.ImageChanged()">
							</td>
							<td>
								<input onclick="opener.OpenImageExplorer();" style="font-size:11px;font-family:Verdana"
									type="button" value="...">
							</td>
						</tr>
						<tr>
							<td style="font-size:11px;font-family:Verdana">Надпись:</td>
							<td colspan="2">
								<input id="txtImageAlt" type="text" style="font-size:11px;font-family:Verdana;width:100%">
							</td>
						</tr>
					</table>
				</fieldset>
				<fieldset>
					<legend>
						Вид</legend>
					<table cellpadding="1">
						<tr>
							<td style="font-size:11px;font-family:Verdana">Выравнивание:</td>
							<td>
								<select onchange="opener.ImagePreviewUpdate()" id="cmbImageAlign" style="font-size:11px;font-family:Verdana">
									<option value=""></option>
									<option value="left">Left</option>
									<option value="center">Center</option>
									<option value="right">Right</option>
									<option value="texttop">TextTop</option>
									<option value="AbsMiddle">AbsMiddle</option>
									<option value="Baseline">Baseline</option>
									<option value="AbsBottom">AbsBottom</option>
									<option value="Middle">Middle</option>
									<option value="Top">Top</option>
								</select>
							</td>
						</tr>
						<tr>
							<td style="font-size:11px;font-family:Verdana">Граница:</td>
							<td>
								<input onchange="opener.ImagePreviewUpdate()" id="txtImageBorder" type="text" style="width:30px;font-size:11px;font-family:Verdana;">
							</td>
						</tr>
					</table>
				</fieldset>
				<table cellpadding="0" cellspacing="0" width="100%" style="font-size:11px;font-family:Verdana">
					<tr>
						<td>
							<fieldset>
								<legend>
									Поля</legend>
								<table cellpadding="1">
									<tr>
										<td style="font-size:11px;font-family:Verdana" nowrap>По горизонтали:</td>
										<td width="100%">
											<input onchange="opener.ImagePreviewUpdate()" id="txtImageHSpace" type="text" style="width:30px;font-size:11px;font-family:Verdana">
										</td>
									</tr>
									<tr>
										<td style="font-size:11px;font-family:Verdana" nowrap>По вертикали:</td>
										<td>
											<input onchange="opener.ImagePreviewUpdate()" id="txtImageVSpace" type="text" style="width:30px;font-size:11px;font-family:Verdana">
										</td>
									</tr>
								</table>
							</fieldset>
						</td>
						<td>&nbsp;</td>
						<td>
							<fieldset>
								<legend>
									Размеры</legend>
								<table cellpadding="1">
									<tr>
										<td style="font-size:11px;font-family:Verdana">Ширина:</td>
										<td width="100%">
											<input onchange="opener.ImagePreviewUpdate()" id="txtImageWidth" type="text" style="width:30px;font-size:11px;font-family:Verdana">
										</td>
									</tr>
									<tr>
										<td style="font-size:11px;font-family:Verdana">Высота:</td>
										<td>
											<input onchange="opener.ImagePreviewUpdate()" id="txtImageHeight" type="text" style="width:30px;font-size:11px;font-family:Verdana">
										</td>
									</tr>
								</table>
							</fieldset>
						</td>
					</tr>
				</table>
			</td>
			<td width="160px" style="font-size:11px;font-family:Verdana" valign="bottom">
				<fieldset>
					<legend>
						Просмотр</legend>
					<div style="overflow:auto;width:150px;height:163px;margin:5px;background:#ffffff;padding:2px;">
						<img id="imgPreview">этот текст пред наз начен для де монст рации отоб раже ния 
						изо браже ния с данны ми опция ми, слова раз биты для на гляд ности
					</div>
				</fieldset>
			</td>
		</tr>
		<tr>
			<td align="right" colspan="2">
				<fieldset>
					<table width="100%" cellpadding="2" border="0">
						<tr>
							<td align="right">
								<input type="button" value="ОК" onclick="opener.InsertImage_Ok();" style="width:70px;font-size:11px;font-family:Verdana">
								<input type="button" value="Отмена" onclick="window.close();" style="width:70px;font-size:11px;font-family:Verdana">
							</td>
						</tr>
					</table>
				</fieldset>
			</td>
		</tr>
	</table>
</div>
<!--/Диалоговое окно "Вставка изображения"-->
<!--Диалоговое окно "Вставка таблицы"-->
<div id="SotaHtmlEditor_insert_table_dialog" style="display:none">
	<table width="100%" cellpadding="1">
		<tr>
			<td>
				<fieldset>
					<table width="100%" style="font-size:11px;font-family:Verdana" cellpadding="1">
						<tr>
							<td>Строки:</td>
							<td><input type="text" value="3" id="txtRows" style="font-size:11px;font-family:Verdana"></td>
							<td>Выравнивание:</td>
							<td>
								<select id="cmbAlign" style="font-size:11px;font-family:Verdana">
									<option value=""></option>
									<option value="center">По центру</option>
									<option value="left">По левому краю</option>
									<option value="right">По правому краю</option>
								</select>
							</td>
						</tr>
						<tr>
							<td>Столбцы:</td>
							<td><input type="text" value="3" id="txtColumns" style="font-size:11px;font-family:Verdana"></td>
							<td>CellPadding:</td>
							<td><input type="text" id="txtCellP" style="font-size:11px;font-family:Verdana"></td>
						</tr>
						<tr>
							<td>Ширина:</td>
							<td><input type="text" id="txtWidth" style="font-size:11px;font-family:Verdana"></td>
							<td>CellSpacing:</td>
							<td><input type="text" id="txtCellS" style="font-size:11px;font-family:Verdana"></td>
						</tr>
						<tr>
							<td>Высота:</td>
							<td><input type="text" id="txtHeight" style="font-size:11px;font-family:Verdana"></td>
							<td>Class:</td>
							<td><input type="text" id="txtClass" style="font-size:11px;font-family:Verdana"></td>
						</tr>
						<tr>
							<td>Граница:</td>
							<td><input type="text" id="txtBorder" style="font-size:11px;font-family:Verdana"></td>
							<td>Style:</td>
							<td><input type="text" id="txtStyle" style="font-size:11px;font-family:Verdana"></td>
						</tr>
					</table>
				</fieldset>
			</td>
		</tr>
		<tr>
			<td align="right">
				<fieldset>
					<table width="100%" cellpadding="2" border="0">
						<tr>
							<td align="right">
								<input type="button" value="ОК" onclick="opener.InsertTable_Ok();" style="width:70px;font-size:11px;font-family:Verdana">
								<input type="button" value="Отмена" onclick="window.close();" style="width:70px;font-size:11px;font-family:Verdana">
							</td>
						</tr>
					</table>
				</fieldset>
			</td>
		</tr>
	</table>
</div>
<!--/Диалоговое окно "Вставка таблицы"-->
<table class="SotaHtmlEditor_all" id="txtBody_all" height="100%" width="100%" border="0">
	<tbody>
		<tr>
			<td class="SotaHtmlEditor_toolbar" id="txtBody_toolbar">
				<span></span><a title="ОК" href="javascript: Ok_Click();"><img src="<%=img%>/save.gif">
				</a><a title="Отмена" href="javascript: Cancel_Click();"><img src="<%=img%>/close.gif">
				</a><span></span><a title="Вставить ссылку" href="javascript: InsertLink();"><img src="<%=img%>/createlink.gif">
				</a><a title="Убрать ссылку" href="javascript:SotaHtmlEditor_ExecCommand('txtBody','UnLink',0);">
					<img src="<%=img%>/unlink.gif"> </a><a title="Вставить изображение" href="javascript: InsertImage();">
					<img src="<%=img%>/insertimage.gif"> </a><a title="Вставить таблицу" href="javascript: InsertTable();">
					<img src="<%=img%>/insert_table.gif"> </a><span></span><a title="Вырезать" href="javascript: SotaHtmlEditor_ExecCommand('txtBody','Cut',1);">
					<img src="<%=img%>/exec_cut.gif"> </a><a title="Копировать" href="javascript: SotaHtmlEditor_ExecCommand('txtBody','Copy',1);">
					<img src="<%=img%>/exec_copy.gif"> </a><a title="Вставить" href="javascript: SotaHtmlEditor_ExecCommand('txtBody','Paste');">
					<img src="<%=img%>/exec_paste.gif"> </a><a title="Удалить" href="javascript: SotaHtmlEditor_ExecCommand('txtBody','Delete',1);">
					<img src="<%=img%>/exec_delete.gif"> </a><span></span><a title="Маркированный список" href="javascript: SotaHtmlEditor_ExecCommand('txtBody','InsertUnorderedList');">
					<img src="<%=img%>/exec_ul.gif"> </a><a title="Нумерованный список" href="javascript: SotaHtmlEditor_ExecCommand('txtBody','InsertOrderedList');">
					<img src="<%=img%>/exec_ol.gif"> </a><span></span><a title="Выровнять по левому краю" href="javascript: SotaHtmlEditor_ExecCommand('txtBody','JustifyLeft');">
					<img src="<%=img%>/exec_jl.gif"> </a><a title="Выровнять по центру" href="javascript: SotaHtmlEditor_ExecCommand('txtBody','JustifyCenter');">
					<img src="<%=img%>/exec_jc.gif"> </a><a title="Выровнять по правому краю" href="javascript: SotaHtmlEditor_ExecCommand('txtBody','JustifyRight');">
					<img src="<%=img%>/exec_jr.gif"> </a><a title="Выровнять по ширине" href="javascript: SotaHtmlEditor_ExecCommand('txtBody','JustifyFull');">
					<img src="<%=img%>/exec_jf.gif"> </a><a title="Отменить выравнивание" href="javascript: SotaHtmlEditor_ExecCommand('txtBody','JustifyNone');">
					<img src="<%=img%>/exec_jn4.gif"> </a><span></span><a title="Уменьшить отступ" href="javascript: SotaHtmlEditor_ExecCommand('txtBody','Outdent');">
					<img src="<%=img%>/exec_outdent.gif"> </a><a title="Увеличить отступ" href="javascript: SotaHtmlEditor_ExecCommand('txtBody','Indent');">
					<img src="<%=img%>/exec_indent.gif"> </a><span></span><a title="Горизонтальная линия" href="javascript: SotaHtmlEditor_InsertHtml('txtBody','<hr>');">
					<img src="<%=img%>/insert_html_hr.gif"> </a><a title="Перенос строки" href="javascript: SotaHtmlEditor_InsertHtml('txtBody','<br>');">
					<img src="<%=img%>/insert_html_br.gif"> </a><span></span><a title="Жирный" href="javascript: SotaHtmlEditor_ExecCommand('txtBody','Bold');">
					<b>Ж</b> </a><a title="Курсив" href="javascript: SotaHtmlEditor_ExecCommand('txtBody','Italic');">
					<i>К</i> </a><a title="Подчеркнутый" href="javascript: SotaHtmlEditor_ExecCommand('txtBody','Underline');">
					<u>Ч</u> </a><a style="text-decoration:line-through" title="Зачеркнутый" href="javascript: SotaHtmlEditor_ExecCommand('txtBody','StrikeThrough');">
					З </a><span></span><a title="Нижний индекс" href="javascript: SotaHtmlEditor_ExecCommand('txtBody','Subscript',1);">
					<img src="<%=img%>/exec_sub.gif"> </a><a title="Верхний индекс" href="javascript: SotaHtmlEditor_ExecCommand('txtBody','Superscript',1);">
					<img src="<%=img%>/exec_sup.gif"> </a>
					<span></span><a title="Нижний регистр" href="javascript: SotaHtmlEditor_ChangeCase('txtBody');">
					ToLower </a><a title="Верхний регистр" href="javascript: SotaHtmlEditor_ChangeCase('txtBody',1);">
					ToUpper </a>
					<div></div>
					<span></span><a title="Показать путь" href="javascript: SotaHtmlEditor_ShowCurrentPath('txtBody');">
					<img src="<%=img%>/show_path.gif"></a><a title="Убрать старое форматирование" href="javascript: SotaHtmlEditor_ClearOldHtml('txtBody');">
					<img src="<%=img%>/clear_all_html.gif">old</a><a title="Убрать стили и классы" href="javascript: SotaHtmlEditor_ClearStyles('txtBody');">
					<img src="<%=img%>/clear_all_html.gif">css</a><a title="Убрать все форматирование" href="javascript: SotaHtmlEditor_ClearAllHtml('txtBody');">
					<img src="<%=img%>/clear_all_html.gif"></a><a title="Убрать форматирование внутри" href="javascript: SotaHtmlEditor_ClearHtml('txtBody');">
					<img src="<%=img%>/clear_html.gif"></a><a title="Объединить форматирование" href="javascript: SotaHtmlEditor_MergeSpan('txtBody');">
					<img src="<%=img%>/merge_span.gif"></a>
				<div></div>
				<span></span>
				<select id="txtBody_tbtn_insert_html_h" onchange="SotaHtmlEditor_InsertHtml('txtBody','<'+this.value+'>','</'+this.value+'>',1);this.selectedIndex=0;">
					<option value="Заголовок" selected>Заголовок</option>
					<option value="h1">h1</option>
					<option value="h2">h2</option>
					<option value="h3">h3</option>
					<option value="h4">h4</option>
					<option value="h5">h5</option>
					<option value="h6">h6</option>
				</select>
				<select id="txtBody_tbtn_format_text_font" onchange="SotaHtmlEditor_FormatText('txtBody','font-size',this.value,1);this.selectedIndex=0;">
					<option value="Размер шрифта" selected>Размер шрифта</option>
					<option value="6px">6px</option>
					<option value="7px">7px</option>
					<option value="8px">8px</option>
					<option value="9px">9px</option>
					<option value="10px">10px</option>
					<option value="11px">11px</option>
					<option value="12px">12px</option>
					<option value="13px">13px</option>
					<option value="14px">14px</option>
					<option value="16px">16px</option>
					<option value="17px">17px</option>
					<option value="18px">18px</option>
				</select>
				<select id="txtBody_tbtn_format_text_color" onchange="SotaHtmlEditor_FormatText('txtBody','color',this.value,1);this.selectedIndex=0;">
					<option value="Цвет шрифта" selected>Цвет шрифта</option>
					<option value="white">white</option>
					<option value="black">black</option>
					<option value="blue">blue</option>
					<option value="red">red</option>
					<option value="green">green</option>
					<option value="yellow">yellow</option>
				</select>
				<select id="txtBody_tbtn_format_text_back_color" onchange="SotaHtmlEditor_FormatText('txtBody','background-color',this.value,1);this.selectedIndex=0;">
					<option value="Цвет фона" selected>Цвет фона</option>
					<option value="white">white</option>
					<option value="black">black</option>
					<option value="blue">blue</option>
					<option value="red">red</option>
					<option value="green">green</option>
					<option value="yellow">yellow</option>
				</select>
				<select id="txtBody_tbtn_insert_symbol" onchange="SotaHtmlEditor_InsertHtml('txtBody',this.value);this.selectedIndex=0;">
					<option value="" selected>Символ</option>
					<option value="&mdash;">&mdash;</option>
					<option value="&laquo;">&laquo;</option>
					<option value="&raquo;">&raquo;</option>
					<option value="&copy;">&copy;</option>
					<option value="&para;">&para;</option>
					<option value="&plusmn;">&plusmn;</option>
					<option value="&reg;">&reg;</option>
					<option value="&frac14;">&frac14;</option>
					<option value="&frac14;">&frac12;</option>
					<option value="&frac14;">&frac34;</option>
					<option value="&trade;">&trade;</option>
					<option value="&oslash;">&oslash;</option>
				</select>
			</td>
		</tr>
		<tr>
			<td class="SotaHtmlEditor_editor" id="txtBody_editor" width="100%" height="100%">
				<div class="SotaHtmlEditor_view" id="txtBody_view" style="WIDTH: 100%; HEIGHT: 100%">
				</div>
				<textarea wrap="off" class="SotaHtmlEditor_txt" id="txtBody" style="DISPLAY: none; WIDTH: 100%; HEIGHT: 100%"
					name="txtBody">
				</textarea>
			</td>
		</tr>
		<tr>
			<td class="SotaHtmlEditor_mode" id="txtBody_mode">
				<div class="selected" id="txtBody_btn_mode_view" onclick="SotaHtmlEditor_ButtonToViewClick('txtBody');">&nbsp;<img src="<%=img%>/mode.view.gif">
					Design</div>
				<div id="txtBody_btn_mode_html" onclick="SotaHtmlEditor_ButtonToHtmlClick('txtBody');">&nbsp;<img src="<%=img%>/mode.html.gif">
					HTML</div>
				&nbsp;&nbsp;<div class="SotaHtmlEditor_path" id="txtBody_path">
				</div>
				<div>
				</div>
			</td>
		</tr>
	</tbody>
</table>
