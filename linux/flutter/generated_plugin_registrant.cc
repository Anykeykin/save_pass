//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <encrypt_decrypt_plus/encrypt_decrypt_plus_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) encrypt_decrypt_plus_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "EncryptDecryptPlusPlugin");
  encrypt_decrypt_plus_plugin_register_with_registrar(encrypt_decrypt_plus_registrar);
}
