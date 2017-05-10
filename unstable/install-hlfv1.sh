(cat > composer.sh; chmod +x composer.sh; exec bash composer.sh)
#!/bin/bash
set -ev

# Get the current directory.
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Get the full path to this script.
SOURCE="${DIR}/composer.sh"

# Create a work directory for extracting files into.
WORKDIR="$(pwd)/composer-data"
rm -rf "${WORKDIR}" && mkdir -p "${WORKDIR}"
cd "${WORKDIR}"

# Find the PAYLOAD: marker in this script.
PAYLOAD_LINE=$(grep -a -n '^PAYLOAD:$' "${SOURCE}" | cut -d ':' -f 1)
echo PAYLOAD_LINE=${PAYLOAD_LINE}

# Find and extract the payload in this script.
PAYLOAD_START=$((PAYLOAD_LINE + 1))
echo PAYLOAD_START=${PAYLOAD_START}
tail -n +${PAYLOAD_START} "${SOURCE}" | tar -xzf -

# Pull the latest Docker images from Docker Hub.
docker-compose pull
docker pull hyperledger/fabric-ccenv:x86_64-1.0.0-alpha

# Kill and remove any running Docker containers.
docker-compose -p composer kill
docker-compose -p composer down --remove-orphans

# Kill any other Docker containers.
docker ps -aq | xargs docker rm -f

# Start all Docker containers.
docker-compose -p composer up -d

# Wait for the Docker containers to start and initialize.
sleep 10

# Create the channel on peer0.
docker exec peer0 peer channel create -o orderer0:7050 -c mychannel -f /etc/hyperledger/configtx/mychannel.tx

# Join peer0 to the channel.
docker exec peer0 peer channel join -b mychannel.block

# Fetch the channel block on peer1.
docker exec peer1 peer channel fetch -o orderer0:7050 -c mychannel

# Join peer1 to the channel.
docker exec peer1 peer channel join -b mychannel.block

# Open the playground in a web browser.
if [ "$(uname)" = "Darwin" ]
then
  open http://localhost:8080
fi

# Exit; this is required as the payload immediately follows.
exit 0
PAYLOAD:
� �Y �][s���g~�u^��'�~���:�MQAAD�ԩwo����j��e2���=��o2A��^��[��z��d_��2���OR�����I���_PE�q����8Fb_j��4�16��Nk�/���N���V���H����4��Ӄ�����CF���h���_^����W�����@+���7������r��dq��_.����^q��:.�?�V������>[ǩ��@�\��P����5|��/��t9��{Lĝ��u�=��t!��'�������g�^+���c�?��.��.�y��S6�6J�4JS�C6�,BQ>B:>���`��x�(��M�Yc���Q��O�"^��8�>��x�Y�K)��p�u'6d�&�B�z�lC��E�T)M��(�2�I}a,0���F)�[e�ւ6U�	�e���i�ϯ}�`!���x�	Z��Աc���#��sݧ(��h��:���OYz8�l%�n���Ri&������Ł��"�-T?�%�^|��}��+��K��ww�o�_���M����������j��|���
��o�?zp�W�?J��S�_8���/�?/�,�|�6o5�,�M���A.s �5e)�ɬ�m�!ǳ�Rܶ���\�&�Y��i�q��e9�k�`jZC�[�� Jq#�D�S�&e�p�u#2�q�pک��)� �6�8�C֐��#u�D]���Ev����A܉�q�jr@1�&��Z=7rw
G� �qEPr�x<X�b�#���s�^=ܟ�-A�(`~n�D�MSى�C�+�?W'Nc9xkcŝ4�s�kfQ6�n$m,lq�0�U�����\�O�"��$ͽ������Nip�3m�P<Q(tzSP(@d���*F����͡]_�w#�L	��0{�nq��V�����Mm@;a���K�*nG(�JK�2qs��3���58O���=!98�ģȓ����/z^ .ԏ���4<�\YR����G��H��eQV���I9h�71��oVL�̖�Q��@���Fc$J�Ms�<0
Q� 	�"xY����Ɂ\&�$�H�Kqc6˨�9�v��oX���[NҖ�FSŋQW2Y1��@�E#�3�^<�F�.����lx6���Y~I�g�����G���K������6����>�������k�/�
�w�;�ׁzd�7�;u��%�-��=q��%��|�!G�8*�#F��P�1��	���#;� � GS�.����̽?�H�?�������J�gF�D���d�{'ZL��%p*k�9jXC"ԗ������ۻr��,�{��c��"�s1����V���( ͽ���K���2��]�թ� �����&́�l���9�zKӔ3#gh�ˋ"�?�|^ o秋�8^���X{x�gB��Z���C]��;����6%�|�H�9��A�A�9lQ��Qt�f��LH��5>�8�hQ�y��k�_
r���M��X����sS��gr]K���m3�>�P�0Y����O�K�ߵ����������R�!������=�?B#t��e���+�����\{����c/�%�����/��3�*��T�?U�ϯ�ҧ� 'Q���f�������); 	h�e0�u(��%�q�#�*���B����Q�ER��W.����=q�w4)h��Hc=A]f��\�������F��/���ec�m+��qCN���o�|�-[ʰ�l��a��%ǜ�L7�t;��=�csc����
p;�nX@�$�m��=�������g��T��������?x���@��W��U���߻��g��T�_
>H���D�O�������L���7s(<:��P�қ�]���O�������:6K}o������`p�{�i2����U�>2�2<�$�zo*ͭ��3A>���w���]����t�x�͆�f2o�z�D���D!P����]�p�r'�v�ó@�D�s�m�ȸ��IG�^p ?G��qڠy,���8�9@z��%�i�V��ڹN�M�|��6Y��.,����μ����´gOM��@�$0A����^��Y��h1	�x�� ��i��=SZ������SMG��v"FR>�9K����Ё��yW 'Y1�������)~I�f�Q���F�O������+�����\{���ߵߝ�r�G���Rp��_��q1��*�/�W�_������C��q���?�8T�%����t���GC�'��]����p����-x�a	�DX�qX$@H�Ei�$)�����P��/��Ch
��2pA��ʄ]�_�V�byñ9�5�f{�9Ҫ�l�m��Rx1�%���q�N+)54$wm'���ǫ{���(ǌ��v��7pD���������=n2�L?�SJN�v�*���x<�����O����D��_� ��'ߙ��?T���\(��ח)��叓H5�K�{�����˗����q��_>R�/m�X�8�����R�;��`8�|�']����O��,�Ѕ��bD�b�cۤ��K�.F!�K�,f{X�������L8��2��VE���_���#��O�������.���}�Z"&
/&�nPo��4L�˹z�t�H�����?�M��]��簺��\��@w��G��p��|�y�H>h��[>#~*�m��C��Z�D\TG��A�ك��W�?��G��������#���+������S��B���+�4�_-T�L�!�W�?� ���Oe��������/�����s Vrt��_c	K ��o���?�g��Y@�>�3���s�=�J���.�j�u#}�F��K��<��Qh�.�{�@C��~شs�ā�ɧ>;�S�żx��ж�1���t�o�0��"F�E7Ӭ����	5��D�Xo�Ql�f:Gm᭸h.)�74L��(g=�@�p[�G1��#�Gz�I��9|��I,̹����p�wk�ʹ�Q�њ����)�,Ԧϩ��;�t�3r�¼�kԥΈ$������>��nk�����9�ۻ����=��"�v6�8�9g��r����b ��P�0�)��v���K4�[�3ۧwKkUׇ��9^(i��Ń}��i;�;�����R�[��^��>g����r~K�!�W��g�?	��򿗂�����������k���;��4r�����>|�ǽ��O��|�o �my�>��} �{ܖ�^��}�4��r�?�=H��ɡ���-*�;��5Y/��Z�o�JOM���C|k�r�Z��0�SٌI2��u��(�Z"��r��դ�Z>�iB���8��Х��cs �5�͑��hmւg�.��}{��Y#Yͥ.���d.���j�l��;�j��7|��N�aFHt��*�>=l<����O����t���MU��෰��g�������Z�����g���������������j��Z���W���ê�.���r��b��(���?KA���W�����o��CQ����+��?�6McJ��P$K��3E">�3ഋ#���>ྏP��9��U��
e����G�_(�Z�)��J˔l99�[�Ԍa��"4����V�X�<�-j���c�鸭��+�{ɚ�zb��vp�*�(�9����Q���w-���3�(C�Sez��RGYl�C�j��{����O��%q�_�����������@�*�g)��iVh������ (�������P�����P�M#;���&��O��1��t�^���C�P�z�\#W�"�ا����4����\�/R�]�$��2Ã�fW���څxիc;����$N���k��FH���׿N犁�K�k-�Ԯ��_O�Q;�w]�*�\W+��¯�z�'�о/t�/4���]�2�ծ��i�����$��v坺`/6������K��}}�S���rmO�~z���bT����Š�­�p;r�V�+}eX�V�hluuA�E��!��:7�o�*]���!ק/�>�r_�fW�v��kU%��|��^�q������\;�BϾ��.:J�'ߺ�o^�-���DYrg��x�ӿ)���ųڋ��=ּe҂H��m��7����3��z�T��bw���Wӻ]��o����������3�X��W[ ����ߩ�y�Χ��ƛ�_kp���0N���R���ƹ.T���#��k��'�h�B"GE��H	����}7@U�ȿ?���Y����?V��Wtñ�E��������w�F���Y��{�@�Uő�m�n�ǧM��3B�+�Ʒ�r��
��$����N�t��ϖ�u�p������q�*����vz.���b��m�-�����|8J'N2��8��R��8��ĉ=v�+�B*�b�?��
�� �� ?vQ+��C]!���� ��ēL���tz[�ϕ�8�{>���y���9V�L�-4���-^�Ŧ�9�`b�˕[r(!a�q(�R���e�||5<��@Wd��s�D�V:KFIhm��1�ɝ���/�e4�"����i=0-�@,���M=
D�yM:&��,� �1aZ�;]]Yt�UEQ\���ZM��p	24A���a�Ԏ�ɀ�a� ���]f\�a�Xxd��ݮf@݄�h<6UIp�>:��G��;����x:�����|)�eXh9�ߪ�u��t_!�-��	W����f��9���9�XFBlQ���<���F�j_4�W���Bi5^�2V5Q;5������^�M��h����t��n�t���)v8]�ɁSN���%8%������tvb�k8�[�_gW�!vr/fWfZ���~$�j�S[5�����ߣ�9��i�]x�I�����Co*�f�&2N��q���?m�\n�ю(����U�Y�p?� ede�ե+�9<����?�����74�
S0~x�\���Շ��r�.���ǖ/C�*�J�\�̔����{�>&ׅ�P䦵F٪Fi�:*�n�au �x�������df�G��?�vt���t�l��kD;�b>�W����sO-5�9��V����ǒ4�DĔ�N��o:�B�.3,h�ߖ�,{<m�u�'�B69��Ç��Z�b���l���ZU��ۅ��]��v��`�Յ�]����Og�V��l�4��^_!8<��7b�����ժ���?^���g��n����y��E<J[v.m��O���]�{l����>V�=>O=���C<��ǃ�`��~^�C�߷��=pJ 5�'1�'����hz��շw_z�����������_n=��D~���pX����np�4�|ݍ��a ����|�x�y��5�א�][����'�Â��}v��� ^ܕ��ts��7��<0!瑃�,�ؼ0`���oR�G��9i�\�,��A�<�����ma�7���a�B�' ��p�@�w#�>�M��^�7�-�qj���^!X��{��1'��\��1UuPh��0,��>hFY�Xq"�,6ó~�6sK�d�$�Q$�9��-\��T�o��`B��u4> dCf�<���p6̓3�U������e)���GC-��͔%�R*U_��/)٪e���L�#%��o��p�@���W�u���bD�����д�߬D2�����}ȗ/9LX�	�0a7a�"_>a�#&�2�"ltnSO�������蚟�R3B�`啕���#J	|#�mh����_'=�t(�V��Th�*4�*:4��?���\/i\�;���hO�i9��-o��Rh�q�鐕��=.�e���a��tc9�������G�d��
�����vQz�C{e2��:m��F1��F�����L �扆�'Qh9N�
�^k(��}��m��Mv?�,QjI��8�ی�;v�W_Y��,k6`]P�=on���]�$�Ψ`<
zS-�rű��
/9���=j��c�a-R��LGn3�R��=|��1��6���>s:e!9�-e����R��e\��u�̒�^�]�,q�GF�!��i��	�S��P� �Ӌ�ռ/�l�2�Y�2���A\Ç�=,�3�X#��\�8(���@"%��F��k�,�U�2\�,�㕥������@��ܫ	E���AH)Faxj�MK���.�?Բ��!Kc��QR��ս�B75�U�|�%��(�PZx
�)��%*�Jb#���� �qO6W8lIY�/ȮU.����B��zc�J]B��(���F��)��ϧ�l�S�8q���*=4ںХ�b�Wj��r,���j���t���S��9>��m��\"�h�����%��uyrm�Nd�B.����ع��y�Q����#�₲o�˳�\�ϳ}�|UY������w�7��� ��u��E�G�wy���a�<�P�h�ʨJC! ���HA�.�(��;��IL!+]�a��0�������c��H�m��h��j���=Vkr��������y����g�q��tۃs���&�~o_�en���&��+���r�ȽP��v̕g�-3=1/3����A�}\&5�Ť��#?G����G~��`P�#Ȫn�<37r p�F�~68;ƶ?��#�O"/�F~�����ay�C��P��C�s'Nݓ���l���f��'Ja*T�D�{����ҹ/<h�#%��:��F�I�Zt0V��<�+�M�Ypp�h��.88k�<��f�Dt Nz��SѶ�e(�7fv�ְL�uӈ���8���{F�S�$�`10�4!Z�K���/c�@w�J/B�6�dӆP	4��p�%}�*G&�`�@Xk�0YL�|�����yLN���xh����33*M��A�aУ�^2uO��,�(�\+��:��ŃcB�PK�����J�Q�A=�'�l�q��;��1��Cf���YߣL/b8Ժ�ah�P���ͫ-�K�<�&D�X�p;���c'���C/��mЩ|�sy�􇦎�|��ϴa���E���e��lg8�yg��D˻��'f����8����ˉ��q"i�N"���ߪDki��"u!�ś��K
d���G'�T�E�&)�̓"�BPdg��Z&A��f�Y�p~>L�\�,C8���9�$�VF�X:Cbr7cz�¸����pF.ƫ��@���i�1��G�j���8��d�IH�xi>r4N9��P��~�~_ �X����n�w �=�a|,�I��]�!�~ig`�\��ޘ`�ú_��ȴ��K�q̃���� ��I��������7:nȩ=�D���hT��B���IO�Y��c�v���r��1��7�8���]��m�yO�-�� ��QHn�0��M����]>�r�#�zO��t+Z����ߞF4�ZMC4���] �������PR�T��� �����^����#KqT�I�~\D. w�n�M`3�~��������C��؟��/=���؋�}���A�1�᭡:<|��nNZL+?T?�:N��������$��q}�������������}�����������?������O�/%�� ܺ����Z\��]ј|NԨ!;���%?t�����G[����ݾ?��������<��� �b�_�Q;�F^^�v�ҡv:�N������C�t�����:i' �P;j�C�t|6�g{=P;Oͷ��|�� UnB���zX䂦��h o[E�e<b��[ϙ:c�?��?�yi��������8�R�W���1�8^3��8�g`�2��|�4���:O��fƉ�:��8�8�8��8���m�f��������e΍�Ý"��)m��%��#����� m�;&���$'9�I���Wʁk�  