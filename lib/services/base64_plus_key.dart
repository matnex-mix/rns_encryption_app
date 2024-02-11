List<String> base64l = [
  "A","B","C","D","E","F","G","H",
  "I","J","K","L","M","N","O","P",
  "Q","R","S","T","U","V","W","X",
  "Y","Z","a","b","c","d","e","f",
  "g","h","i","j","k","l","m","n",
  "o","p","q","r","s","t","u","v",
  "w","x","y","z","0","1","2","3",
  "4","5","6","7","8","9","+","/"
];

List<int> toBytes(String str) {
  List<int> re = [];
  for(int i = 0; i < str.length; i++) {
    int ch = str.codeUnitAt(i);
    re.add(ch & 0xFF);
  }
  return re.reversed.toList();
}

String toBinaryString(String str) {
  bool t = true;
  List<String> s = [];
  int n = int.parse(str);
  while(t) {
    s.add((n % 2).toString());
    n = (n / 2).floor();
    if(n == 0) {
      t = false;
    }
  }
  return s.reversed.join('');
}

List<String> copyString(int n) {
  return List<String>.filled(n, '', growable: true);
}

String encryption(String text) {
  List<int> b = toBytes(text);
  List<String> bin = copyString(b.length);
  int len = (8 * bin.length) ~/ 6;
  if(((8 * bin.length) % 6) != 0) len = len + 1;
  List<String> bin6 = copyString(len);
  String combined = "", all = "";
  for(int x = 0; x < bin.length; x++) {
    bin[x] = toBinaryString(b[x].toString());
    if(bin[x].length != 8) {
      for(int i = 0; i < 8 - bin[x].length; i++) {
        bin[x] = "0" + bin[x];
      }
    }
    combined += bin[x];
  }
  for(int i = 0, x = 6; x <= combined.length; x = x + 6, i++) {
    bin6[i] = combined.substring(x - 6, x);
    all += base64l[int.parse(bin6[i], radix: 2)];
    if(x + 6 > combined.length && (i + 1) < bin6.length) {
      bin6[i + 1] = combined.substring(x);
      all += base64l[int.parse(bin6[i + 1], radix: 2)];
    }
  }
  if(bin6.length % 4 != 0) {
    for(int x = 0; x < 4 - (bin6.length % 4); x++) {
      all += "=";
    }
  }
  return all;
}

String bkey(List<String> tk) {
  List<String> bin6 = b6(tk[0]);
  List<String> kbin6 = b6(tk[1]);
  String combined = "";
  for(int x = 0; x < bin6.length; x++) {
    for(int d = 0; d < kbin6.length; d++) {
      bin6[x] = toBinaryString((int.parse(bin6[x], radix: 2) ^ int.parse(kbin6[d], radix: 2)).toString());
    }
    combined += base64l[int.parse(bin6[x], radix: 2)];
  }
  if(combined.length % 4 != 0) {
    int cmb = 4 - (combined.length % 4);
    for(int x = 0; x < cmb; x++) {
      combined += "=";
    }
  }
  return combined;
}

String dkey(List<String> tk) {
  String combined = "";
  List<String> pr = [];
  List<String> pre = [];
  List<String> bin = [];
  List<String> kbin = [];
  List<int> b = [];
  String stext = tk[0].replaceAll("=", "");
  while(stext.indexOf("=") != -1) {
    stext = stext.replaceAll("=", "");
  }
  List<String> texts = copyString(stext.length);
  for(int x = 0; x < stext.length; x++) {
    texts[x] = stext.substring(x, x + 1);
  }
  pr = copyString(texts.length);
  for(int x = 0; x < texts.length; x++) {
    for(int i = 0; i < base64l.length; i++) {
      if(texts[x] == base64l[i]) {
        pr[x] = toBinaryString(i.toString());
        int len = 6 - pr[x].length;
        for(int xi = 0; xi < len && x < texts.length - 1; xi++) {
          pr[x] = "0" + pr[x];
        }
        break;
      }
    }
  }
  pre = b6(tk[1]);
  combined = "";
  for(int d = 0; d < pr.length; d++) {
    for(int dd = 0; dd < pre.length; dd++) {
      pr[d] = toBinaryString((int.parse(pr[d], radix: 2) ^ int.parse(pre[dd], radix: 2)).toString());
    }
    int len = 6 - pr[d].length;
    for(int xi = 0; xi < len; xi++) {
      pr[d] = "0" + pr[d];
    }
    combined += pr[d];
  }
  int x = (combined.length / 8).floor();
  if((combined.length % 8) != 0) x = x + 1;
  bin = copyString(x);
  b = copyString(x).map((e) => 0).toList();
  for(int i = 0, x = 8; x <= combined.length; x = x + 8, i++) {
    bin[i] = combined.substring(x - 8, x);
    b[i] = int.parse(bin[i], radix: 2);
    if(x + 8 > combined.length) {
      bin.add(combined.substring(x));
      break;
    }
  }
  combined = "";
  for(int x = 0; x < b.length; x++) {
    if(x == b.length - 1 && b[x] == 0) break;
    combined += String.fromCharCode(b[x]);
  }
  return combined;
}

List<String> b6(String text) {
  List<int> b = toBytes(text);
  List<String> bin = copyString(b.length);
  int len = (8 * bin.length) ~/ 6;
  if(((8 * bin.length) % 6) != 0) len = len + 1;
  List<String> bin6 = copyString(len);
  String combined = "";
  for(int x = 0; x < bin.length; x++) {
    bin[x] = toBinaryString(b[x].toString());
    if(bin[x].length != 8) {
      int bln = 8 - bin[x].length;
      for(int i = 0; i < bln && x < bin.length - 1; i++) {
        bin[x] = "0" + bin[x];
      }
    }
    combined += bin[x];
  }
  for(int i = 0, x = 6; x <= combined.length; x = x + 6, i++) {
    bin6[i] = combined.substring(x - 6, x);
    if(x + 6 > combined.length) {
      bin6[i + 1] = combined.substring(x);
      int len = 6 - bin6[i + 1].length;
      for(int xi = 0; xi < len; xi++) {
        bin6[i + 1] = "0" + bin6[i + 1];
      }
      break;
    }
  }
  return bin6;
}